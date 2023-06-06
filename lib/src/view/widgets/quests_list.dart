import 'package:flutter/material.dart';

import '../../data/models/quest.dart';
import 'quest_tile.dart';

class QuestsList extends StatelessWidget {
  final List<Quest> items;

  const QuestsList({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: items.isNotEmpty ? items.length : 1,
      itemBuilder: (_, index) {
        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Text('Поки немає квестів для відображення'),
            ),
          );
        }

        final quest = items[index];

        return QuestTile(
          questName: quest.name,
          isRepeated: quest.interval != null,
          deadline: quest.deadline,
        );
      },
      separatorBuilder: (_, __) => const Divider(),
    );
  }
}
