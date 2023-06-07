import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/app_route.dart';
import '../../data/models/quest.dart';
import '../../data/models/quest_category.dart';
import '../../data/models/skill.dart';
import '../../data/user_data.dart';
import '../../services/http/fetch/quests_fetch_service.dart';
import '../../services/http/util/fetch_service_bundle.dart';
import '../../typedefs.dart';
import '../../util/extensions/context_synchronizer.dart';
import '../widgets/add_button.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/quests_list.dart';

class _QuestsPageData with ChangeNotifier {
  List<QuestCategory?> categories = [null];
  List<Skill?> skills = [null];
  bool _isFiltersLoaded = false;

  QuestCategory? _filterCategory;
  Skill? _filterSkill;

  List<Quest> _quests = [];
  bool _isLoaded = false;
  DioError? _error;

  QuestCategory? get filterCategory => _filterCategory;

  bool get isFiltersLoaded => _isFiltersLoaded;

  DioError? get error => _error;

  set error(DioError? error) {
    _error = error;
    notifyListeners();
  }

  set isFiltersLoaded(bool value) {
    _isFiltersLoaded = value;
    notifyListeners();
  }

  set filterCategory(QuestCategory? category) {
    _filterCategory = category;
    notifyListeners();
  }

  Skill? get filterSkill => _filterSkill;

  set filterSkill(Skill? skill) {
    _filterSkill = skill;
    notifyListeners();
  }

  bool get isLoaded => _isLoaded;

  set isLoaded(bool value) {
    _isLoaded = value;
    notifyListeners();
  }

  List<Quest> get quests => _quests;

  set quests(List<Quest> value) {
    _quests = value;
    notifyListeners();
  }
}

class QuestsPage extends StatefulWidget {
  const QuestsPage({super.key});

  @override
  State<QuestsPage> createState() => _QuestsPageState();
}

class _QuestsPageState extends State<QuestsPage> {
  late final _QuestsPageData _data = _QuestsPageData();
  late final QuestsFetchService _questsFetchService;

  @override
  void initState() {
    super.initState();
    _loadFilters();
    _fetchFilteredQuests();
  }

  Future<void> _loadFilters() async {
    final bundle = context.read<FetchServiceBundle>();
    _questsFetchService = bundle.questsFetchService;
    final categoriesFetcher = bundle.categoriesFetchService;
    final skillsFetcher = bundle.skillsFetchService;

    final results = await Future.wait([categoriesFetcher.getMany(), skillsFetcher.getMany()])
        .then((res) => res.map((res) => res.result().data));

    if (!mounted) return;

    _data.categories.addAll(results.first as List<QuestCategory>);
    _data.skills.addAll(results.last as List<Skill>);
    _data.isFiltersLoaded = true;
  }

  Future<void> _fetchFilteredQuests() async {
    _data.isLoaded = false;

    if (_data.filterCategory == null && _data.filterSkill == null) {
      _data.quests = context.read<UserData>().quests;
      _data.isLoaded = true;
      return;
    }

    final questsRes =
        await _questsFetchService.getMany().then((res) => res.transform((data) => data.data));

    if (!questsRes.isSuccessful) {
      _data.error = questsRes.error;
      return;
    }

    _data.quests = questsRes.result();
    _data.isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<_QuestsPageData>.value(
      value: _data,
      builder: (_, __) => LayoutSelector(
        mobileLayoutBuilder: (context) => _MobileQuestsPage(
          filterUpdateCallback: _fetchFilteredQuests,
        ),
        desktopLayoutBuilder: (context) => const Placeholder(),
      ),
    );
  }
}

class _MobileQuestsPage extends StatelessWidget {
  final VoidCallback _filterUpdateCallback;

  const _MobileQuestsPage({required VoidCallback filterUpdateCallback})
      : _filterUpdateCallback = filterUpdateCallback;

  @override
  Widget build(BuildContext context) {
    return Consumer<_QuestsPageData>(
      builder: (context, data, _) {
        return MobileLayout(
          appBar: AppBar(title: const Text('Квести')),
          floatingActionButton: AddButton(
            onPressed: () => context
                .push(AppRoute.editQuest.route)
                .whenComplete(context.synchronizer().syncQuests),
          ),
          children: [
            if (data.isFiltersLoaded)
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(),
                  child: Row(
                    children: [
                      Expanded(
                        child: _QuestsFilter<Skill?>(
                          caption: 'Навичка',
                          items: data.skills,
                          initialSelection: null,
                          onChanged: (skill) {
                            if (data.filterSkill == skill) return;
                            data.filterSkill = skill;
                            _filterUpdateCallback();
                          },
                          presenter: (skill) => skill?.name ?? 'Всі',
                        ),
                      ),
                      const SizedBox.square(dimension: 8),
                      Expanded(
                        child: _QuestsFilter<QuestCategory?>(
                          caption: 'Категорія',
                          items: data.categories,
                          initialSelection: null,
                          onChanged: (category) {
                            if (data.filterCategory == category) return;
                            data.filterCategory = category;
                            _filterUpdateCallback();
                          },
                          presenter: (category) => category?.name ?? 'Всі',
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              const Center(
                child: CircularProgressIndicator(),
              ),
            if (data.error == null)
              Card(
                child: data.isLoaded
                    ? QuestsList(items: data.quests)
                    : const CircularProgressIndicator(),
              )
            else
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(data.error?.message ?? 'Сталась помилка'),
                ),
              )
          ],
        );
      },
    );
  }
}

typedef StringTPresenter<T> = String Function(T);

class _QuestsFilter<T> extends StatelessWidget {
  final String caption;
  final List<T> items;
  final T initialSelection;
  final Callback<T?> onChanged;
  final StringTPresenter<T> presenter;

  const _QuestsFilter({
    required this.items,
    required this.caption,
    required this.initialSelection,
    required this.onChanged,
    required this.presenter,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      isExpanded: true,
      onChanged: onChanged,
      value: initialSelection,
      decoration: InputDecoration(labelText: caption),
      items: items.map((item) {
        return DropdownMenuItem<T>(
          value: item,
          child: Text(presenter(item)),
        );
      }).toList(growable: false),
    );
  }
}
