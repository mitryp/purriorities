import 'package:flutter/material.dart';

import 'quest_tile.dart';

class QuestsList extends StatelessWidget {
  final List<(String name, bool isRepeated, DateTime? deadline)> items;

  const QuestsList({required this.items, super.key});

  @override
  Widget build(BuildContext context) {
      return ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final (questName, isRepeated, deadline) = items[index];

          return QuestTile(questName: questName, isRepeated: isRepeated, deadline: deadline);
        },
        separatorBuilder: (context, index) => const Divider(),
      );
  }
}