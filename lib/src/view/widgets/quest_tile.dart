import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../app.dart';
import '../../data/models/quest.dart';
import '../../typedefs.dart';
import '../pages/single_quest_page/single_quest_page.dart';

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
      title: Text(quest.name, style: quest.priority.textStyleWithColor),
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
      onTap: () => _redirectToSingleQuestPage(context),
    );
  }

  Future<void> _redirectToSingleQuestPage(BuildContext context) async {
    final commData = await rootNavigatorKey.currentState!.push<CommunicationData>(
      MaterialPageRoute(builder: (context) => SingleQuestPage(quest)),
    );
  }
}
