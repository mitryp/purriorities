import 'package:flutter/material.dart';

import '../../data/models/quest.dart';
import '../../typedefs.dart';
import 'quest_tile.dart';

class QuestsList extends StatelessWidget {
  final List<Quest> items;
  final bool isFiltered;
  final bool useSliverList;
  final bool shrinkWrap;

  const QuestsList({
    required this.items,
    this.isFiltered = false,
    this.useSliverList = false,
    this.shrinkWrap = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ListBuilder listBuilder = useSliverList
        ? SliverList.separated
        : ({
            addAutomaticKeepAlives = true,
            addRepaintBoundaries = true,
            addSemanticIndexes = true,
            findChildIndexCallback,
            required itemBuilder,
            required itemCount,
            key,
            required separatorBuilder,
          }) =>
            ListView.separated(
              shrinkWrap: shrinkWrap,
              addAutomaticKeepAlives: addAutomaticKeepAlives,
              addRepaintBoundaries: addRepaintBoundaries,
              addSemanticIndexes: addSemanticIndexes,
              findChildIndexCallback: findChildIndexCallback,
              itemBuilder: itemBuilder,
              itemCount: itemCount,
              separatorBuilder: separatorBuilder,
            );

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
