import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../common/enums/app_route.dart';
import '../../../data/models/skill.dart';
import '../../../services/helpers/pagination_data.dart';
import '../../../services/http/fetch/quests_fetch_service.dart';
import '../../../services/http/util/fetch_service_bundle.dart';
import '../../../util/extensions/context_synchronizer.dart';
import '../../../util/extensions/string_ellipsis.dart';
import '../../widgets/add_button.dart';
import '../../widgets/authorizer.dart';
import '../../widgets/categories_drawer.dart';
import '../../widgets/layouts/layout_selector.dart';
import '../../widgets/layouts/mobile.dart';
import '../../widgets/quests_list.dart';
import 'quests_filter.dart';
import 'quests_page_data.dart';

class QuestsPage extends StatefulWidget {
  const QuestsPage({super.key});

  @override
  State<QuestsPage> createState() => _QuestsPageState();
}

class _QuestsPageState extends State<QuestsPage> {
  late final QuestsPageData _data = QuestsPageData();
  late final QuestsFetchService _questsFetchService;

  @override
  void initState() {
    super.initState();
    _loadFilters().whenComplete(_fetchFilteredQuests);
  }

  Future<void> _loadFilters() async {
    final bundle = context.read<FetchServiceBundle>();
    _questsFetchService = bundle.questsFetchService;
    final skillsFetcher = bundle.skillsFetchService;

    final skills = await skillsFetcher.getMany().then((res) => res.result().data);

    if (!mounted) return;

    _data.skills.addAll(skills);
    _data.areFiltersLoaded = true;
  }

  Future<void> _fetchFilteredQuests() async {
    _data.isLoaded = false;

    final filterCategory = _data.filterCategory;
    final filterSkill = _data.filterSkill;

    final PaginationData paginationData = PaginationData(
      filter: {
        if (filterCategory != null) 'categoryId': filterCategory.id,
        if (filterSkill != null) 'questSkills.(skillId)': filterSkill.id,
      },
      sort: null,
      page: null,
      limit: null,
    );

    final questsRes = await _questsFetchService
        .getMany(paginationData)
        .then((res) => res.transform((data) => data.data));

    if (!questsRes.isSuccessful) {
      _data.error = questsRes.error;
      return;
    }

    _data.quests = questsRes.result();
    _data.isLoaded = true;
  }

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: ChangeNotifierProvider<QuestsPageData>.value(
        value: _data,
        builder: (_, __) => LayoutSelector(
          mobileLayoutBuilder: (context) => _MobileQuestsPage(
            filterUpdateCallback: _fetchFilteredQuests,
          ),
          desktopLayoutBuilder: (context) => const Placeholder(),
        ),
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
    return Consumer<QuestsPageData>(
      builder: (context, questsPageData, _) {
        const categoryNameLength = 15;
        final filterCategory = questsPageData.filterCategory;

        return MobileLayout.child(
          appBar: AppBar(
            title: const Text('Квести'),
            actions: [
              if (filterCategory != null) ...[
                Chip(
                  label: Text(
                    filterCategory.name.ellipsis(categoryNameLength),
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                  onDeleted: () {
                    questsPageData.filterCategory = null;
                    _filterUpdateCallback();
                  },
                ),
                const SizedBox(width: 4),
              ],
              Builder(
                builder: (context) => IconButton(
                  tooltip: 'Фільтр за категоріями',
                  onPressed: Scaffold.of(context).openEndDrawer,
                  icon: const Icon(Icons.category),
                ),
              )
            ],
          ),
          endDrawerEnableOpenDragGesture: false,
          endDrawer: CategoriesDrawer(
            onCategorySelected: (category) {
              questsPageData.filterCategory = category;
              _filterUpdateCallback();
            },
          ),
          floatingActionButton: AddButton(
            onPressed: () => context
                .push(AppRoute.editQuest.route)
                .whenComplete(context.synchronizer().syncQuests),
          ),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: !questsPageData.areFiltersLoaded && !questsPageData.isLoaded
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: QuestsFilter<Skill?>(
                                      caption: 'Навичка',
                                      items: questsPageData.skills,
                                      initialSelection: null,
                                      onChanged: (skill) {
                                        if (questsPageData.filterSkill == skill) return;
                                        questsPageData.filterSkill = skill;
                                        _filterUpdateCallback();
                                      },
                                      presenter: (skill) => skill?.name ?? 'Всі',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
              if (questsPageData.error == null)
                QuestsList(
                  items: questsPageData.quests,
                  isFiltered: questsPageData.areFiltersApplied,
                  useSliverList: true,
                )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Center(
                      child: Text(questsPageData.error?.message ?? 'Сталась помилка'),
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
