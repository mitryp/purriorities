part of 'single_quest_page.dart';

class _QuestInfoTiles extends StatelessWidget {
  static final DateFormat _deadlineFormat = DateFormat('dd.MM.yyyy\nHH:mm');

  final Quest quest;
  final TextStyle priorityTextStyle;

  const _QuestInfoTiles(this.quest, {required this.priorityTextStyle});

  @override
  Widget build(BuildContext context) {
    final deadline = quest.deadline;
    final isDeadlineMissed =
        !quest.isFinished && (quest.deadline?.isBefore(DateTime.now()) ?? false);
    final interval = quest.interval;

    late final errorColor = Theme.of(context).colorScheme.error;

    final statusTextStyle = TextStyle(
      color: isDeadlineMissed
          ? errorColor
          : (quest.isFinished ? QuestPriority.optional : QuestPriority.regular).color,
    );

    final List<(String, String, TextStyle?)> tileEntries = [
      (
        'Статус',
        quest.isFinished ? 'Завершений' : (isDeadlineMissed ? 'Протермінований' : 'Активний'),
        statusTextStyle
      ),
      if (!quest.isFinished && deadline != null)
        (
          isDeadlineMissed ? 'Протерміновано на' : 'Часу залишилось',
          formatDuration(deadline.difference(DateTime.now())),
          isDeadlineMissed ? TextStyle(color: errorColor) : null,
        ),
      ('Кінцевий термін', deadline != null ? _deadlineFormat.format(deadline) : 'Не вказано', null),
      ('Категорія', quest.category.name, null),
      ('Пріоритетність', quest.priority.label.capitalize(), priorityTextStyle),
      (
        'Інтервал',
        interval != null ? 'Раз на $interval ${formatDays(interval)}' : 'Не повторюється',
        null,
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

class _QuestStageDisplay extends StatelessWidget {
  static const WidgetSpan _finishedStageCheck = WidgetSpan(
    child: Padding(
      padding: EdgeInsets.only(right: 8),
      child: Icon(
        Icons.check,
        color: Colors.green,
      ),
    ),
  );
  static const TextStyle _stageLabelStyle = TextStyle(fontSize: 17);
  static const EdgeInsets _contentPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static const EdgeInsets _titlePadding = EdgeInsets.only(bottom: 8);
  static const double _wrapSpacing = 8.0;

  final int index;
  final QuestStage stage;

  const _QuestStageDisplay(this.stage, {required this.index});

  @override
  Widget build(BuildContext context) {
    final questWrapper = context.watch<NotifierWrapper<Quest>>();

    return Card(
      child: ListTile(
        contentPadding: _contentPadding,
        title: Padding(
          padding: _titlePadding,
          child: Text.rich(
            TextSpan(
              children: [
                if (stage.isFinished) _finishedStageCheck,
                TextSpan(text: stage.name),
              ],
            ),
            style: _stageLabelStyle,
          ),
        ),
        subtitle: Wrap(
          spacing: _wrapSpacing,
          runSpacing: 0,
          children: stage.tasks
              .map(
                (task) => _QuestTaskSelectionChip(
                  task,
                  questWrapper: questWrapper,
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _QuestTaskSelectionChip extends StatelessWidget {
  final Task task;
  final NotifierWrapper<Quest> questWrapper;

  const _QuestTaskSelectionChip(this.task, {required this.questWrapper});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(task.name),
      onSelected: task.isPending ? (_) => _openCompletionDialog(context) : null,
      selected: task.isNotPending,
    );
  }

  Future<void> _openCompletionDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => TaskManagementDialog(task, questWrapper: questWrapper),
    );
  }
}
