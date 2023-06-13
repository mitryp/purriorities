part of 'single_quest_page.dart';

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
    final sync = context.synchronizer();

    final res = await showDialog<dynamic>(
      context: context,
      builder: (context) => TaskManagementDialog(
        task,
        tasksService: TasksService(context, context.read<Dio>()),
        questWrapper: questWrapper,
      ),
    );

    unawaited(sync.syncUser());

    // ignore: use_build_context_synchronously
    if (!context.mounted || res == null) return;

    if (res is Reward) {
      questWrapper.data = questWrapper.data.setTaskStatus(task.id, isCompleted: true);
      unawaited(showRewardPunishmentDialog(context: context, reward: res));
    } else if (res is TaskRefuseResponse) {
      questWrapper.data = questWrapper.data.setTaskStatus(task.id, isCompleted: false);
      unawaited(showRewardPunishmentDialog(context: context, refuseResponse: res));
    }

    if (questWrapper.data.isFinished) unawaited(sync.syncQuests());
  }
}
