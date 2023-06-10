import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/quest.dart';
import '../dialogs/task_completion_dialog.dart';

class QuestTile extends StatelessWidget {
  final Quest quest;
  final double trailingSpacing;

  const QuestTile(
    this.quest, {
    this.trailingSpacing = 8.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deadline = quest.deadline;
    final isRepeated = quest.interval != null;

    return ListTile(
      title: Text(quest.name),
      trailing: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: trailingSpacing,
        runSpacing: trailingSpacing,
        children: [
          if (isRepeated) const Icon(Icons.restart_alt_rounded),
          if (deadline != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(DateFormat('HH:mm').format(deadline)),
                Text(DateFormat('dd.MM.yyyy').format(deadline)),
              ],
            )
          else
            const Text('В зручний час'),
        ],
      ),
      onTap: () => showDialog<void>(
        context: context,
        builder: (BuildContext context) => const TaskCompletionDialog(),
      ),
    );
  }
}
