import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../dialogs/task_completion_dialog.dart';

class QuestTile extends StatelessWidget {
  final String questName;
  final bool isRepeated;
  final DateTime? deadline;

  const QuestTile({
    required this.questName,
    required this.isRepeated,
    this.deadline,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(questName),
      trailing: FractionallySizedBox(
        widthFactor: 0.4,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (isRepeated) const Icon(Icons.restart_alt_rounded),
            const SizedBox(width: 20),
            _buildDeadlineSection(),
          ],
        ),
      ),
      onTap: () => showDialog<void>(
        context: context,
        builder: (BuildContext context) => const TaskCompletionDialog(),
      ),
    );
  }

  Widget _buildDeadlineSection() {
    if (deadline != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(DateFormat('HH:mm').format(deadline!)),
          Text(DateFormat('dd.MM.yyyy').format(deadline!)),
        ],
      );
    }

    return const Text('В зручний час');
  }
}
