import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../data/enums/quest_priority.dart';
import '../../../data/models/quest.dart';
import '../../../data/models/quest_stage.dart';
import '../../../data/models/skill.dart';
import '../../../data/models/task.dart';
import '../../../data/util/notifier_wrapper.dart';
import '../../../data/util/validators.dart';
import '../../../typedefs.dart';
import '../../../util/datetime_comparison.dart';
import '../../../util/extensions/datetime_extensions.dart';
import '../../../util/minutes_format.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../../dialogs/task_edit_dialog.dart';
import '../../theme.dart';
import '../../widgets/date_time_selector_fields/date_selector_form_field.dart';
import '../../widgets/date_time_selector_fields/datetime_editing_controller.dart';
import '../../widgets/date_time_selector_fields/time_selector_form_field.dart';
import '../../widgets/error_snackbar.dart';
import '../../widgets/layouts/layout_selector.dart';
import '../../widgets/layouts/mobile.dart';
import '../../widgets/priority_selector.dart';
import '../../widgets/quest_skill_tile/quest_skill_tile.dart';

part 'quest_schedule_tile.dart';

part 'quest_skills_selector.dart';

part 'quest_stages_editor.dart';

class QuestEditPage extends StatelessWidget {
  final Quest? initialQuest;

  const QuestEditPage({this.initialQuest, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final deadline = DateTime.now().add(const Duration(days: 1));

        return NotifierWrapper<Quest>(
          initialQuest ??
              const Quest.empty().copyWithSchedule(
                deadline: deadline,
                limit: deadline,
                interval: 1,

                // todo remove
                skills: const [
                  Skill(
                    name: 'Нявати',
                    level: 100,
                    levelExp: 10,
                    id: 0,
                  ),
                  Skill(
                    name: 'Мурати',
                    level: 70,
                    levelExp: 90,
                    id: 1,
                  ),
                  Skill(
                    name: 'Кицяти',
                    level: 80,
                    levelExp: 20,
                    id: 2,
                  ),
                  Skill(
                    name: 'Перегортатися',
                    level: 50,
                    levelExp: 25,
                    id: 3,
                  ),
                ],
                stages: [
                  const QuestStage(
                    id: '0',
                    name: 'Етап 1',
                    tasks: [
                      Task(stageId: '0', id: '0', name: 'Кицяти 5 хвилин', minutes: 5),
                      Task(stageId: '0', id: '1', name: 'Перегортатися', minutes: 20),
                      Task(stageId: '0', id: '2', name: 'Мурати весь вечір', minutes: 125),
                      Task(stageId: '0', id: '3', name: 'Нявати щасливо з Катрусею', minutes: 300),
                      Task(stageId: '0', id: '4', name: 'с:', minutes: 1),
                    ],
                  ),
                  const QuestStage(
                    id: '1',
                    name: 'Етап 2',
                    tasks: [
                      Task(stageId: '1', id: '0', name: 'Цьомати', minutes: 300),
                      Task(stageId: '1', id: '1', name: ';3', minutes: 1),
                    ],
                  ),
                ],
              ),
        );
      },
      child: LayoutSelector(
        mobileLayoutBuilder: (context) => MobileQuestEditPage(
          isEditing: initialQuest != null,
        ),
        desktopLayoutBuilder: (context) => const Placeholder(),
      ),
    );
  }
}

class MobileQuestEditPage extends StatefulWidget {
  final bool isEditing;

  const MobileQuestEditPage({this.isEditing = false, super.key});

  @override
  State<MobileQuestEditPage> createState() => _MobileQuestEditPageState();
}

class _MobileQuestEditPageState extends State<MobileQuestEditPage> {
  static const _inputRowPadding = EdgeInsets.symmetric(vertical: 8);
  static const _separator = SizedBox.square(dimension: 8);
  static const _divider = Divider(height: 16);

  final GlobalKey<FormState> _formKey = GlobalKey();
  final DateTimeEditingController _deadlineDateController = DateTimeEditingController();
  final TimeEditingController _deadlineTimeController = TimeEditingController();
  final DateTimeEditingController _lastDateController = DateTimeEditingController();

  bool _isPlanerUsed = false;
  bool _isRepeating = false;

  @override
  void dispose() {
    _deadlineDateController.dispose();
    _deadlineTimeController.dispose();
    _lastDateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<NotifierWrapper<Quest>>();
    final quest = data.data;

    return MobileLayout.child(
      minimumSafeArea: MobileLayout.defaultSafeArea.copyWith(left: 16, right: 16),
      appBar: AppBar(
        title: Text('${widget.isEditing ? 'Редагувати' : 'Створити'} квест'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _processQuestSaving,
        child: const Icon(Icons.save),
      ),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: notEmpty,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    initialValue: quest.name,
                    onChanged: _changeNameFor(data, quest),
                    decoration: const InputDecoration(labelText: 'Назва квесту'),
                  ),
                  _separator,
                  _separator,
                  _PriorityCategoryRow(
                    selectedPriority: quest.priority,
                    onPriorityChanged: _changePriorityFor(data, quest),
                    separator: _separator,
                  ),
                  _separator,
                  _divider,
                  _ScheduleTile(
                    isPlanerUsed: _isPlanerUsed,
                    onPlanerModeChanged: (isPlanerUsed) =>
                        setState(() => _isPlanerUsed = isPlanerUsed),
                    isRepeating: _isRepeating,
                    onRepeatingModeChanged: (isRepeating) =>
                        setState(() => _isRepeating = isRepeating),
                    childrenPadding: _inputRowPadding,
                    separator: _separator,
                    deadlineDateController: _deadlineDateController,
                    deadlineTimeController: _deadlineTimeController,
                    lastDateController: _lastDateController,
                  ),
                  _divider,
                  _separator,
                ],
              ),
            ),
          ),
          SliverList.list(
            children: const [
              _QuestSkillsSelector(),
              _divider,
              _QuestStagesEditor(),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _processQuestSaving() async {
    if (!_validateQuest()) return;
    // context.pop();
  }

  bool _validateQuest() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      showErrorSnackBar(
        context: context,
        content: const ErrorSnackBarContent(titleText: 'У квеста повинна бути назва'),
      );
      return false;
    }

    final quest = context.read<NotifierWrapper<Quest>>().data;

    if (quest.stages.isEmpty) {
      showErrorSnackBar(
        context: context,
        content: const ErrorSnackBarContent(titleText: 'Квест повинен мати принаймні один етап'),
      );

      return false;
    }

    if (quest.stages.any((stage) => stage.tasks.isEmpty)) {
      showErrorSnackBar(
        context: context,
        content: const ErrorSnackBarContent(
          titleText: 'Кожен етап повинен містити хоча б одне завдання',
          subtitleText: 'Спробуйте додати завдання, або видалити зайвий етап',
        ),
      );

      return false;
    }

    log('Successfully validated', name: 'QuestEditPage');
    return true;
  }

  Callback<QuestPriority> _changePriorityFor(NotifierWrapper<Quest> wrapper, Quest quest) =>
      (priority) {
        if (quest.priority == priority) return;

        wrapper.data = quest.copyWith(priority: priority);
      };

  Callback<String> _changeNameFor(NotifierWrapper<Quest> wrapper, Quest quest) => (name) {
        if (quest.name == name) return;

        wrapper.data = quest.copyWith(name: name);
      };
}

class _PriorityCategoryRow extends StatelessWidget {
  final QuestPriority selectedPriority;
  final Callback<QuestPriority> onPriorityChanged;
  final Widget separator;

  const _PriorityCategoryRow({
    required this.selectedPriority,
    required this.onPriorityChanged,
    required this.separator,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PrioritySelector(
            onPriorityChanged: onPriorityChanged,
            selected: selectedPriority,
          ),
        ),
        separator,
        Expanded(
          child: Card(
            margin: EdgeInsets.zero,
            child: InkWell(
              onTap: () {}, //todo
              borderRadius: defaultBorderRadius,
              child: const ListTile(
                title: FittedBox(child: Text('Обрати категорію', textAlign: TextAlign.center)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
