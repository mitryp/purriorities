import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/communication_data_status.dart';
import '../../data/models/skill.dart';
import '../../data/util/validators.dart';
import '../../services/http/fetch/skills_fetch_service.dart';
import '../../services/http/util/fetch_service_bundle.dart';
import '../../typedefs.dart';
import '../dialogs/confirmation_dialog.dart';
import '../widgets/authorizer.dart';
import '../widgets/error_snack_bar.dart';
import '../widgets/layouts/form_layout.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_indicator_button.dart';

class SkillsEditPage extends StatelessWidget {
  final Skill? skill;

  const SkillsEditPage({this.skill, super.key});

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: ChangeNotifierProvider(
        create: (_) => _SkillEditData(skill?.name),
        child: LayoutSelector(
          mobileLayoutBuilder: (_) => _MobileSkillsEditPage(skill: skill),
          desktopLayoutBuilder: (_) => const Placeholder(),
        ),
      ),
    );
  }
}

class _MobileSkillsEditPage extends StatefulWidget {
  final Skill? skill;

  const _MobileSkillsEditPage({this.skill});

  @override
  State<_MobileSkillsEditPage> createState() => _MobileSkillsEditPageState();
}

class _MobileSkillsEditPageState extends State<_MobileSkillsEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  bool get _isEditing => widget.skill != null;

  SkillsFetchService get _skillsFetcher => context.read<FetchServiceBundle>().skillsFetchService;

  @override
  Widget build(BuildContext context) {
    return MobileLayout.child(
      appBar: AppBar(
        title: Text('${_isEditing ? 'Редагування' : 'Створення'} навички'),
        actions: [
          if (_isEditing)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(onPressed: _processSkillDeletion, icon: const Icon(Icons.delete)),
            ),
        ],
      ),
      child: Card(
        child: Consumer<_SkillEditData>(
          builder: (context, skillData, _) => FormLayout(
            form: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: TextFormField(
                  initialValue: skillData.name,
                  decoration: const InputDecoration(labelText: 'Назва навички'),
                  onChanged: (value) => skillData.name = value,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: notEmpty,
                ),
              ),
            ),
            trailing: [
              const SizedBox(height: 16),
              if (skillData.error != null)
                Text(
                  skillData.error?.message ?? 'Сталася помилка',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ProgressIndicatorButton(
                buttonBuilder: OutlinedButton.new,
                onPressed: _processSkillSaving,
                child: const Text('Зберегти'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processSkillSaving() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final name = context.read<_SkillEditData>().name;

    final initialSkill = widget.skill;

    final res = initialSkill != null
        ? await _skillsFetcher.update(
            initialSkill.id,
            initialSkill.copyWith(name: name),
            oldSerializable: initialSkill,
          )
        : await _skillsFetcher.create(Skill.create(name: name));

    if (!mounted) return;

    if (res.isSuccessful) {
      context.pop<CommunicationData<Skill>>(
        (
          data: res.result(),
          status: _isEditing ? CommunicationDataStatus.updated : CommunicationDataStatus.created
        ),
      );
      return;
    }

    showErrorSnackBar(
      context: context,
      content: ErrorSnackBarContent(
        titleText: 'Не вдалось ${_isEditing ? 'створити' : 'оновити'} навичку',
        subtitleText: 'Повідомлення від сервера: ${res.errorMessage}',
      ),
    );
  }

  Future<void> _processSkillDeletion() async {
    final skill = widget.skill;

    if (skill == null) return;

    final isConfirmed = await showConfirmationDialog(
      context: context,
      title: 'Ви дійсно хочете видалити навичку "${skill.name}"?',
      prompt: 'Рівень навички буде втрачено, цю дію не можна скасувати',
      confirmLabelText: 'Так',
      denyLabelText: 'Ні',
      titleStyle: const TextStyle(fontSize: 17),
      promptStyle: const TextStyle(fontSize: 15),
    );

    if (!isConfirmed) return;

    final res = await _skillsFetcher.delete(skill.id);
    final deleted = res.isSuccessful;

    if (!mounted) return;

    if (deleted) {
      context.pop<CommunicationData<Skill>>((data: null, status: CommunicationDataStatus.deleted));
      return;
    }

    showErrorSnackBar(
      context: context,
      content: ErrorSnackBarContent(
        titleText: 'Під час видалення навички сталася помилка',
        subtitleText: 'Повідомлення від сервера: ${res.errorMessage}',
      ),
    );
  }
}

class _SkillEditData with ChangeNotifier {
  String _name;

  DioError? _error;

  _SkillEditData([String? skillName]) : _name = skillName ?? '';

  String get name => _name;

  set name(String name) {
    _name = name;
    notifyListeners();
  }

  DioError? get error => _error;

  set error(DioError? error) {
    _error = error;
    notifyListeners();
  }
}
