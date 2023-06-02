import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/models/quest.dart';
import '../../data/models/quest_stage.dart';
import '../../data/models/task.dart';
import '../../data/util/notifier_wrapper.dart';
import '../../typedefs.dart';

class TaskEditDialog extends StatefulWidget {
  final NotifierWrapper<Quest> questNotifier;
  final Task task;
  final bool isEditing;

  const TaskEditDialog({
    required this.questNotifier,
    required this.task,
    required this.isEditing,
    super.key,
  });

  @override
  State<TaskEditDialog> createState() => _TaskEditDialogState();
}

class _TaskEditDialogState extends State<TaskEditDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: FittedBox(
              child: Text('${widget.isEditing ? 'Редагувати' : 'Стаорити'} задачу'),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteTask,
          )
        ],
      ),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: widget.task.name,
              onChanged: _changeTaskName(),
            )
          ],
        ),
      ),
      actions: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.check),
          label: const Text('Готово'),
        )
      ],
    );
  }

  Callback<String> _changeTaskName() {
    return (name) {
      _updateOrCreateTask(widget.task.copyWith(name: name));
      if (name.isEmpty) {
        _deleteTask(willPop: false);
      }
    };
  }

  /// Replaces the task with the respective id and stageId with the given [task] in the quest if
  /// the [task] is present in the stage.
  /// If not, adds the task at the end of the stage task list.
  void _updateOrCreateTask(Task task) {
    _withTasksInfo((quest, stages, stageIndex, tasks, taskIndex) {
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

  void _deleteTask({bool willPop = true}) {
    _withTasksInfo((quest, stages, stageIndex, tasks, taskIndex) {
      final stage = stages[stageIndex];

      tasks.removeAt(taskIndex);
      stages
        ..removeAt(stageIndex)
        ..insert(stageIndex, stage.copyWith(tasks: tasks));

      return quest.copyWith(stages: stages);
    });

    if (willPop) {
      context.pop();
    }
  }

  void _withTasksInfo(
    Quest Function(
      Quest quest,
      List<QuestStage> stages,
      int stageIndex,
      List<Task> tasks,
      int taskIndex,
    ) func,
  ) {
    final wrapper = widget.questNotifier;
    final quest = wrapper.data;
    final task = widget.task;

    final stages = quest.stages.toList();
    final stageIndex = stages.indexWhere((stage) => stage.id == task.stageId);
    final stage = stages[stageIndex];
    final tasks = stage.tasks.toList();
    final taskIndex = tasks.indexWhere(
      (t) => t.id == task.id && t.stageId == task.stageId,
    );

    final newQuest = func(quest, stages, stageIndex, tasks, taskIndex);

    wrapper.data = newQuest;
  }
}
