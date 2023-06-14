import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app.dart';
import '../../common/util/helping_functions.dart';
import '../../data/models/quest.dart';
import '../pages/single_quest_page/single_quest_page.dart';

class QuestTile extends StatelessWidget {
  final Quest quest;
  final double trailingSpacing;
  final VoidCallback? filtersUpdateCallback;

  const QuestTile(
    this.quest, {
    this.trailingSpacing = 8.0,
    this.filtersUpdateCallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final deadline = quest.deadline;
    final isRepeated = quest.interval != null;

    final deadlineTextStyle = TextStyle(
      color: deadlineMissed(quest) ? Theme.of(context).colorScheme.error : null,
    );

    final priorityColor = quest.priority.color;
    final titleColor = !quest.isFinished ? priorityColor : priorityColor.withOpacity(0.8);

    return ListTile(
      title: Text(
        quest.name,
        style: quest.priority.textStyle.copyWith(
            color: titleColor,
            decoration: quest.isFinished ? TextDecoration.lineThrough : null,
            decorationColor: priorityColor),
      ),
      trailing: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: trailingSpacing,
        runSpacing: trailingSpacing,
        children: [
          if (isRepeated) const Icon(Icons.restart_alt_rounded),
          if (quest.isFinished)
            const Text('Завершено')
          else if (deadline != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('HH:mm').format(deadline),
                  style: deadlineTextStyle,
                ),
                Text(
                  DateFormat('dd.MM.yyyy').format(deadline),
                  style: deadlineTextStyle,
                ),
              ],
            )
          else
            const Text('В зручний час'),
        ],
      ),
      onTap: () => _redirectToSingleQuestPage(context),
    );
  }

  Future<void> _redirectToSingleQuestPage(BuildContext context) async {
    await rootNavigatorKey.currentState!.push<void>(
      MaterialPageRoute(builder: (context) => SingleQuestPage(quest)),
    );

    filtersUpdateCallback?.call();
  }
}
