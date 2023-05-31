import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../data/enums/quest_priority.dart';
import '../../../data/models/quest.dart';
import '../../../data/models/quest_stage.dart';
import '../../../data/models/skill.dart';
import '../../../data/models/task.dart';
import '../../../data/util/notifier_wrapper.dart';
import '../../../typedefs.dart';
import '../../../util/datetime_comparison.dart';
import '../../../util/extensions/datetime_extensions.dart';
import '../../../util/extensions/widget_list_extensions.dart';
import '../../theme.dart';
import '../../widgets/date_time_selector_fields/date_selector_form_field.dart';
import '../../widgets/date_time_selector_fields/datetime_editing_controller.dart';
import '../../widgets/date_time_selector_fields/time_selector_form_field.dart';
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
              const Quest.empty().copyWith(
                deadline: deadline,
                limit: deadline,
                interval: 1,
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
      minimumSafeArea: MobileLayout.defaultSafeArea.copyWith(top: 0, left: 16, right: 16),
      appBar: AppBar(
        title: Text('${widget.isEditing ? 'Існуючий' : 'Новий'} квест'),
      ),
      child: CustomScrollView(
        shrinkWrap: true,
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              Form(
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: quest.name,
                      onChanged: _changeNameFor(data, quest),
                      decoration: const InputDecoration(labelText: 'Назва квесту'),
                    ),
                    _PriorityCategoryRow(
                      selectedPriority: quest.priority,
                      onPriorityChanged: _changePriorityFor(data, quest),
                      separator: _separator,
                    ),
                    _ScheduleTile(
                      isPlanerUsed: _isPlanerUsed,
                      onPlanerModeChanged: (isPlanningEnabled) => setState(
                        () => _isPlanerUsed = isPlanningEnabled,
                      ),
                      isRepeating: _isRepeating,
                      onRepeatingModeChanged: (isRepeating) => setState(
                        () => _isRepeating = isRepeating,
                      ),
                      childrenPadding: _inputRowPadding,
                      separator: _separator,
                      deadlineDateController: _deadlineDateController,
                      deadlineTimeController: _deadlineTimeController,
                      lastDateController: _lastDateController,
                    ),
                  ].separate(_separator),
                ),
              ),
              const _QuestSkillsSelector(),
            ]),
          )
        ],
      ),
    );
  }

  Callback<QuestPriority> _changePriorityFor(NotifierWrapper<Quest> wrapper, Quest quest) =>
      (newPriority) => wrapper.data = quest.copyWithPreserveSchedule(priority: newPriority);

  Callback<String> _changeNameFor(NotifierWrapper<Quest> wrapper, Quest quest) =>
      (name) => wrapper.data = quest.copyWithPreserveSchedule(name: name);
}

class _PriorityCategoryRow extends StatelessWidget {
  final QuestPriority selectedPriority;
  final Callback<QuestPriority> onPriorityChanged;
  final Widget separator;

  const _PriorityCategoryRow({
    required this.selectedPriority,
    required this.onPriorityChanged,
    required this.separator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PrioritySelector(
          onPriorityChanged: onPriorityChanged,
          selected: selectedPriority,
        ),
        Card(
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () {}, //todo
            borderRadius: defaultBorderRadius,
            child: const ListTile(
              title: FittedBox(child: Text('Обрати категорію', textAlign: TextAlign.center)),
            ),
          ),
        ),
      ].wrap((child) => Expanded(child: child)).separate(separator),
    );
  }
}
