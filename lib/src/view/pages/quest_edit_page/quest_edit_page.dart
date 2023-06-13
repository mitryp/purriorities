import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/enums/quest_priority.dart';
import '../../../data/models/quest.dart';
import '../../../data/models/quest_stage.dart';
import '../../../data/models/skill.dart';
import '../../../data/models/task.dart';
import '../../../data/user_data.dart';
import '../../../data/util/notifier_wrapper.dart';
import '../../../data/util/validators.dart';
import '../../../services/http/util/fetch_service_bundle.dart';
import '../../../typedefs.dart';
import '../../../util/datetime_comparison.dart';
import '../../../util/extensions/datetime_extensions.dart';
import '../../../util/time_format.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../../dialogs/task_edit_dialog.dart';
import '../../theme.dart';
import '../../widgets/authorizer.dart';
import '../../widgets/categories_drawer.dart';
import '../../widgets/date_time_selector_fields/date_selector_form_field.dart';
import '../../widgets/date_time_selector_fields/datetime_editing_controller.dart';
import '../../widgets/date_time_selector_fields/time_selector_form_field.dart';
import '../../widgets/error_snack_bar.dart';
import '../../widgets/layouts/layout_selector.dart';
import '../../widgets/layouts/mobile.dart';
import '../../widgets/priority_selector.dart';
import '../../widgets/quest_skill_tile/quest_skill_tile.dart';
import 'quest_skills_selector_delegate.dart';

part 'quest_schedule_tile.dart';
part 'quest_skills_selector.dart';
part 'quest_stages_editor.dart';

class QuestEditPage extends StatelessWidget {
  final Quest? initialQuest;

  const QuestEditPage({this.initialQuest, super.key});

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: ChangeNotifierProvider(
        create: (context) {
          late final deadline = DateTime.now().add(const Duration(days: 1));
          late final defaultCategory = context.read<UserData>().defaultCategory!;

          return NotifierWrapper<Quest>(
            initialQuest ??
                Quest.empty(category: defaultCategory).copyWithSchedule(
                  deadline: deadline,
                  limit: deadline,
                  interval: 1,
                ),
          );
        },
        child: LayoutSelector(
          mobileLayoutBuilder: (context) => MobileQuestEditPage(
            isEditing: initialQuest != null,
          ),
          desktopLayoutBuilder: (context) => const Placeholder(),
        ),
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
        actions: const [SizedBox()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _processQuestSaving,
        child: const Icon(Icons.save),
      ),
      endDrawerEnableOpenDragGesture: false,
      endDrawer: CategoriesDrawer(
        onCategorySelected: (category) => data.data = quest.copyWith(category: category),
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

    final service = context.read<FetchServiceBundle>().questsFetchService;
    final rawQuest = context.read<NotifierWrapper<Quest>>().data;

    final quest = context.read<NotifierWrapper<Quest>>().data.copyWithSchedule(
          deadline: _isPlanerUsed ? rawQuest.deadline : null,
          limit: _isPlanerUsed && _isRepeating ? rawQuest.limit : null,
          interval: _isPlanerUsed && _isRepeating ? rawQuest.interval : null,
        );

    final res = await service.create(quest);
    if (!mounted) return;

    if (res.isSuccessful) {
      final data = context.read<UserData>();
      data.addQuest(res.result());
      context.pop();

      return;
    }

    showErrorSnackBar(
      context: context,
      content: ErrorSnackBarContent(
        titleText: 'Сталась помилка під час створення квесту',
        subtitleText: res.errorMessage,
      ),
    );
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
            child: Consumer<NotifierWrapper<Quest>>(
              builder: (context, wrapper, _) => InkWell(
                onTap: Scaffold.of(context).openEndDrawer,
                borderRadius: defaultBorderRadius,
                child: ListTile(
                  title: Text(
                    wrapper.data.category.name,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
