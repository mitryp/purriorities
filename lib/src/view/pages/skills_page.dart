import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/app_route.dart';
import '../../common/enums/communication_data_status.dart';
import '../../data/models/skill.dart';
import '../../services/http/util/fetch_service_bundle.dart';
import '../../typedefs.dart';
import '../widgets/add_button.dart';
import '../widgets/authorizer.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/skill_tile.dart';

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
        floatingActionButton: AddButton(
          onPressed: () => _redirectToEditPage(context, skillsData: data),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        children: [
          if (!data.isLoaded)
            const Center(child: CircularProgressIndicator())
          else if (data.error == null)
            if (data.skills.isNotEmpty)
              ...data.skills.map(
                (skill) => SkillTile(
                  skill,
                  onPressed: () => _redirectToSkillEdit(context, skill),
                ),
              )
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

  Future<void> _redirectToEditPage(BuildContext context, {required _SkillsData skillsData}) async {
    final commData = await context.push<CommunicationData<Skill>>(AppRoute.editSkill.route);
    final skill = commData?.data;

    // ignore: use_build_context_synchronously
    if (!context.mounted || skill == null || commData?.status != CommunicationDataStatus.created) {
      return;
    }

    skillsData.skills = skillsData.skills
      ..add(skill)
      ..sort((a, b) => a.level - b.level);
  }

  Future<void> _redirectToSkillEdit(BuildContext context, Skill skill) async {
    final commData = await context.push<CommunicationData<Skill>>(
      AppRoute.editSkill.route,
      extra: skill,
    );
    final status = commData?.status;

    // ignore: use_build_context_synchronously
    if (!context.mounted || status == null) return;

    final skillsData = context.read<_SkillsData>();
    final skills = skillsData.skills;

    final index = skills.indexWhere((s) => s.id == skill.id);
    skills.removeAt(index);

    if (status == CommunicationDataStatus.updated) {
      skills.insert(index, commData!.data!);
    }

    skillsData.skills = skills;
  }
}

class _SkillsData with ChangeNotifier {
  List<Skill> _skills = [];
  bool _isLoaded = false;
  DioError? _error;

  List<Skill> get skills => _skills;

  set skills(List<Skill> value) {
    _skills = value;
    notifyListeners();
  }

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
    if (isLoaded) return;

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
