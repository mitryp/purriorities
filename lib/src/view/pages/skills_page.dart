import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/skill.dart';
import '../../services/http/util/fetch_service_bundle.dart';
import '../widgets/add_button.dart';
import '../widgets/authorizer.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_bars/progress_bar.dart';

class _SkillsData with ChangeNotifier {
  List<Skill> skills = [];
  bool _isLoaded = false;
  DioError? _error;

  bool get isLoaded => _isLoaded;

  set isLoaded(bool value) {
    _isLoaded = value;
    notifyListeners();
  }

  DioError? get error => _error;

  set error(DioError? error) {
    _error = error;
    notifyListeners();
  }

  Future<void> _load(BuildContext context) async {
    final bundle = context.read<FetchServiceBundle>();
    final skillsFetcher = bundle.skillsFetchService;

    final res = await skillsFetcher.getMany();

    if (!res.isSuccessful) {
      _error = res.error;
      return;
    }

    skills = res.map((res) => res.data);
    isLoaded = true;
  }
}

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  final _SkillsData _data = _SkillsData();

  @override
  void initState() {
    super.initState();

    _data._load(context);
  }

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: ChangeNotifierProvider<_SkillsData>.value(
        value: _data,
        child: LayoutSelector(
          mobileLayoutBuilder: (context) => const _MobileSkillsPage(),
          desktopLayoutBuilder: (context) => const Placeholder(),
        ),
      ),
    );
  }
}

class _MobileSkillsPage extends StatelessWidget {
  const _MobileSkillsPage();

  @override
  Widget build(BuildContext context) {
    return Consumer<_SkillsData>(
      builder: (context, data, _) => MobileLayout(
        //TODO onPressed => form for creating new skill
        floatingActionButton: AddButton(onPressed: () {}),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        children: [
          if (!data.isLoaded)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (data.error == null)
            if (data.skills.isNotEmpty)
              ...data.skills.map((skill) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: ProgressBar(
                      height: 50,
                      overlayingWidget: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text(skill.name), Text('Рівень ${skill.level}')],
                        ),
                      ),
                      value: skill.levelExp,
                      maxValue: skill.levelCap,
                    ),
                  ),
                );
              })
            else
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Center(
                  child: Text(
                    'Ви ще не додали жодної навички! Для цього скористайтеся кнопкою нижче',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
          else
            Center(child: Text(data.error?.message ?? 'Сталася помилка'))
        ],
      ),
    );
  }
}
