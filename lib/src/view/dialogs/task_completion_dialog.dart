import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../common/enums/sprite.dart';
import '../../data/models/quest.dart';
import '../../data/models/task.dart';
import '../../data/util/notifier_wrapper.dart';
import '../../services/tasks_service.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/error_snack_bar.dart';
import '../widgets/progress_indicator_button.dart';
import 'confirmation_dialog.dart';
import 'reward_punishment_dialog.dart';

class TaskManagementDialog extends StatelessWidget {
  final Task task;
  final NotifierWrapper<Quest> questWrapper;
  final TasksService tasksService;

  const TaskManagementDialog(
    this.task, {
    required this.tasksService,
    required this.questWrapper,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        elevatedButtonTheme: const ElevatedButtonThemeData(
          style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.black)),
        ),
      ),
      child: AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Image.asset(
              Sprite.grayCat.animatedAsset,
              scale: scaleTo(50),
              filterQuality: FilterQuality.none,
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 32, left: 3),
              child: ChatBubble('Няв?'),
            ),
          ],
        ),
        content: const Text('Няв, якщо виконали завдання :3'),
        actionsAlignment: MainAxisAlignment.center,
        actionsOverflowAlignment: OverflowBarAlignment.center,
        actions: <Widget>[
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green[300])),
            onPressed: () => _processTaskCompletion(context),
            child: const Text('Няв'),
          ),
          ProgressIndicatorButton.elevated(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red[300]),
            ),
            onPressed: () => _processTaskRefuse(context),
            child: const Text('Відмовитися'),
          ),
          ProgressIndicatorButton.elevated(
            style: ButtonStyle(foregroundColor: MaterialStatePropertyAll(Colors.grey[300])),
            onPressed: context.pop,
            child: const Text('Просто кицяю'),
          ),
        ],
      ),
    );
  }

  Future<void> _processTaskCompletion(BuildContext context) async {
    final rewardRes = await tasksService.completeTask(task.id);

    // ignore: use_build_context_synchronously
    if (!context.mounted) return;

    if (!rewardRes.isSuccessful) {
      showErrorSnackBar(
        context: context,
        content: ErrorSnackBarContent(
          titleText: 'Під час виконання запиту сталася помилка',
          subtitleText: 'Повідомлення від сервера: ${rewardRes.errorMessage}',
        ),
      );

      return;
    }

    log('got: ${rewardRes.result()}');

    context.pop(rewardRes.result());
  }

  Future<void> _processTaskRefuse(BuildContext context) async {
    final isConfirmed = await showConfirmationDialog(
      context: context,
      prompt: 'Якщо ви відмовитеся від завдання, ви можете втратити довіру котиків!\n'
          'Ви точно хочете відмовитися?',
      confirmLabelText: 'Так',
      denyLabelText: 'Ні',
    );

    // ignore: use_build_context_synchronously
    if (!isConfirmed || !context.mounted) return;

    final refuseRes = await tasksService.refuseTask(task.id);

    // ignore: use_build_context_synchronously
    if (!context.mounted) return;

    if (!refuseRes.isSuccessful) {
      showErrorSnackBar(
        context: context,
        content: ErrorSnackBarContent(
          titleText: 'Під час виконання запиту сталася помилка',
          subtitleText: 'Повідомлення від сервера: ${refuseRes.errorMessage}',
        ),
      );

      return;
    }

    log('got: ${refuseRes.result()}');

    context.pop(refuseRes.result());
  }
}
