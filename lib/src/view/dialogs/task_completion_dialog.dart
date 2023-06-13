import 'package:flutter/material.dart';

import '../../common/enums/sprite.dart';
import '../../data/models/quest.dart';
import '../../data/models/task.dart';
import '../../data/util/notifier_wrapper.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/chat_bubble.dart';

class TaskManagementDialog extends StatelessWidget {
  final Task task;
  final NotifierWrapper<Quest> questWrapper;

  const TaskManagementDialog(this.task, {required this.questWrapper, super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Image.asset(
            Sprite.grayCat.asset,
            scale: scaleTo(50),
            filterQuality: FilterQuality.none,
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 32.0, left: 3.0),
            child: ChatBubble('Няв?'),
          ),
        ],
      ),
      content: const Text('Няв, якщо виконали завдання :3'),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.red[300])),
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Просто кицяю',
            style: TextStyle(color: Colors.black),
          ),
        ),
        ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.green[300])),
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Няв',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
