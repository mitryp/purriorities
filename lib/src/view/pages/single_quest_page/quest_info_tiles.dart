part of 'single_quest_page.dart';

class _QuestInfoTiles extends StatelessWidget {
  static final DateFormat _deadlineFormat = DateFormat('dd.MM.yyyy\nHH:mm');

  final Quest quest;
  final TextStyle priorityTextStyle;

  const _QuestInfoTiles(this.quest, {required this.priorityTextStyle});

  @override
  Widget build(BuildContext context) {
    final deadline = quest.deadline;
    final isDeadlineMissed = deadlineMissed(quest);
    final interval = quest.interval;

    late final errorColor = Theme.of(context).colorScheme.error;

    final statusTextStyle = TextStyle(
      color: isDeadlineMissed
          ? errorColor
          : (quest.isRefused ? QuestPriority.optional : QuestPriority.regular).color,
    );

    final defaultTrailingStyle = TextStyle(color: Colors.grey[200]);

    final String questStatusLabel;
    if (quest.isRefused) {
      questStatusLabel = 'Скасований';
    } else if (quest.isFinished) {
      questStatusLabel = 'Завершений';
    } else if (isDeadlineMissed) {
      questStatusLabel = 'Протермінований';
    } else {
      questStatusLabel = 'Активний';
    }

    final List<(String, String, TextStyle?)> tileEntries = [
      ('Статус', questStatusLabel, statusTextStyle),
      if (!quest.isFinished && deadline != null)
        (
          isDeadlineMissed ? 'Протерміновано на' : 'Часу залишилось',
          formatDuration(deadline.difference(DateTime.now())),
          isDeadlineMissed ? TextStyle(color: errorColor) : defaultTrailingStyle,
        ),
      (
        'Кінцевий термін',
        deadline != null ? _deadlineFormat.format(deadline) : 'Не вказано',
        defaultTrailingStyle
      ),
      ('Категорія', quest.category.name, defaultTrailingStyle),
      ('Пріоритетність', quest.priority.label.capitalize(), priorityTextStyle),
      (
        'Інтервал',
        interval != null ? 'Раз на $interval ${formatDays(interval)}' : 'Не повторюється',
        defaultTrailingStyle,
      ),
    ];

    return SliverList.separated(
      separatorBuilder: (_, __) => const Divider(),
      itemCount: tileEntries.length,
      itemBuilder: (_, index) => _QuestInfoEntryTile(tileEntries[index]),
    );
  }
}

class _QuestInfoEntryTile extends StatelessWidget {
  final (String, String, TextStyle?) entry;

  const _QuestInfoEntryTile(this.entry);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(entry.$1),
      trailing: LayoutBuilder(
        builder: (context, constraints) => ConstrainedBox(
          constraints: constraints.widthConstraints() / 2,
          child: Text(
            entry.$2,
            style: entry.$3,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.end,
          ),
        ),
      ),
    );
  }
}
