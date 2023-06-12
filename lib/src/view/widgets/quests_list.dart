import 'package:flutter/material.dart';

import '../../data/models/quest.dart';
import 'quest_tile.dart';

class QuestsList extends StatelessWidget {
  final List<Quest> items;
  final bool isFiltered;
  final bool useSliverList;

  const QuestsList({
    required this.items,
    this.isFiltered = false,
    this.useSliverList = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final listBuilder = useSliverList ? SliverList.separated : ListView.separated;

    return listBuilder(
      itemCount: items.isNotEmpty ? items.length : 1,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (_, index) {
        if (items.isNotEmpty) {
          return QuestTile(items[index]);
        }

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              isFiltered
                  ? 'Жоден квест не відповідає заданим фільтрам'
                  : 'Поки немає квестів для відображення',
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
