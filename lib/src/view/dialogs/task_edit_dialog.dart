import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../data/models/quest.dart';
import '../../data/models/quest_stage.dart';
import '../../data/models/task.dart';
import '../../data/util/notifier_wrapper.dart';
import '../../data/util/validators.dart';
import '../../typedefs.dart';
import 'confirmation_dialog.dart';

class TaskEditDialog extends StatelessWidget {
  final NotifierWrapper<Quest> questNotifier;
  final Task initialTask;
  final bool isEditing;

  const TaskEditDialog({
    required this.questNotifier,
    required this.initialTask,
    required this.isEditing,
    super.key,
  });

  Task get _task => questNotifier.data.stages
      .firstWhere((stage) => stage.id == initialTask.stageId)
      .tasks
      .firstWhere(
        (task) => task.id == initialTask.id,
        orElse: () => initialTask,
      );

  @override
  Widget build(BuildContext context) {
    final titleText = '${isEditing ? 'Редагувати' : 'Створити'} задачу';
    const titleStyle = TextStyle(fontSize: 19);

    return ConfirmationDialog(
      title: Row(
        children: [
          Expanded(
            child: Text(titleText, style: titleStyle),
          ),
          if (isEditing) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteTask(context),
            ),
          ],
        ],
      ),
      promptChildren: [
        TextFormField(
          autofocus: true,
          initialValue: initialTask.name,
          onChanged: _processTaskNameChange(context),
          decoration: const InputDecoration(labelText: 'Зробити...'),
        ),
        TextFormField(
          initialValue: '${initialTask.minutes}',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: _processTaskMinutesChange,
          keyboardType: TextInputType.number,
          validator: all([notEmpty, isPositiveInteger]),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          decoration: InputDecoration(
            labelText: 'Витратити на це...',
            suffixText: Intl.plural(
              initialTask.minutes,
              one: 'хвилину',
              two: 'хвилини',
              few: 'хвилини',
              many: 'хвилин',
              other: 'хвилин',
            ),
          ),
        ),
      ],
      confirmLabel: const Text('Готово'),
    );
  }

  Callback<String> _processTaskNameChange(BuildContext context) {
    return (name) {
      _updateOrCreateTask(_task.copyWith(name: name));
      if (name.isEmpty) {
        _deleteTask(context, userIntended: false);
      }
    };
  }

  void _processTaskMinutesChange(String minutes) {
    final intMinutes = max(int.tryParse(minutes) ?? 1, 1);
    final task = _task;

    if (intMinutes == task.minutes) return;

    _updateOrCreateTask(task.copyWith(minutes: intMinutes));
  }

  /// Replaces the task with the respective id and stageId with the given [task] in the quest if
  /// the [task] is present in the stage.
  /// If not, adds the task at the end of the stage task list.
  void _updateOrCreateTask(Task task) {
    _changeQuestWithTasksInfo((quest, stages, stageIndex, tasks, taskIndex) {
      final stage = stages[stageIndex];

      if (taskIndex != -1) {
        tasks.removeAt(taskIndex);
      }
      tasks.insert(taskIndex != -1 ? taskIndex : tasks.length, task);

      stages
        ..removeAt(stageIndex)
        ..insert(stageIndex, stage.copyWith(tasks: tasks));

      return quest.copyWith(stages: stages);
    });
  }

  Future<void> _deleteTask(BuildContext context, {bool userIntended = true}) async {
    final isConfirmed = !userIntended ||
        await showConfirmationDialog(
          context: context,
          prompt: 'Ви дійсно хочете видалити задачу "${initialTask.name}"?',
          confirmLabelText: 'Так',
          denyLabelText: 'Ні',
        );

    // ignore: use_build_context_synchronously
    if (!context.mounted || !isConfirmed) return;

    _changeQuestWithTasksInfo((quest, stages, stageIndex, tasks, taskIndex) {
      final stage = stages[stageIndex];

      tasks.removeAt(taskIndex);
      stages
        ..removeAt(stageIndex)
        ..insert(stageIndex, stage.copyWith(tasks: tasks));

      return quest.copyWith(stages: stages);
    });

    if (userIntended) {
      context.pop();
    }
  }

  void _changeQuestWithTasksInfo(
    Quest Function(
      Quest quest,
      List<QuestStage> stages,
      int stageIndex,
      List<Task> tasks,
      int taskIndex,
    ) func,
  ) {
    final wrapper = questNotifier;
    final quest = wrapper.data;

    final stages = quest.stages.toList();
    final stageIndex = stages.indexWhere((stage) => stage.id == initialTask.stageId);
    final stage = stages[stageIndex];
    final tasks = stage.tasks.toList();
    final taskIndex = tasks.indexWhere(
      (t) => t.id == initialTask.id && t.stageId == initialTask.stageId,
    );

    final newQuest = func(quest, stages, stageIndex, tasks, taskIndex);

    wrapper.data = newQuest;
  }
}
