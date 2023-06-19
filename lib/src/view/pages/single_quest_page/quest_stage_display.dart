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
          runSpacing: kIsWeb ? _wrapSpacing : 0,
          children: stage.tasks.map(_QuestTaskSelectionChip.new).toList(growable: false),
        ),
      ),
    );
  }
}

class _QuestTaskSelectionChip extends StatelessWidget {
  final Task task;

  const _QuestTaskSelectionChip(this.task);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selectedColor: task.isRefused ? Colors.red[200]!.withOpacity(0.15) : null,
      showCheckmark: task.isFinished,
      label: Text(task.name),
      onSelected: task.isPending ? (_) => _openCompletionDialog(context) : null,
      selected: task.isNotPending,
    );
  }

  Future<void> _openCompletionDialog(BuildContext context) async {
    final questWrapper = context.read<NotifierWrapper<Quest>>();
    Quest quest() => questWrapper.data;

    final sync = context.synchronizer();

    final res = await showDialog<dynamic>(
      context: context,
      builder: (context) => TaskManagementDialog(
        task,
        tasksService: TasksService(context, context.read<Dio>()),
        questWrapper: questWrapper,
      ),
    );

    await sync.syncUser();

    // ignore: use_build_context_synchronously
    if (!context.mounted || res == null || (res is! Reward && res is! TaskRefuseResponse)) return;

    final wasRewarded = res is Reward;
    questWrapper.data = quest().setTaskStatus(task.id, isCompleted: wasRewarded);

    log('wasNewQuestScheduled: '
        '${quest().shouldRepeatAgain} && ${quest().stages.map((stage) => stage.isFinished)}');

    final wasNewQuestScheduled =
        quest().shouldRepeatAgain && quest().stages.every((stage) => stage.isFinished);

    if (wasRewarded) {
      await showRewardPunishmentDialog(
        label: 'Завдання "${task.name}"',
        context: context,
        reward: res,
        wasNewQuestScheduled: wasNewQuestScheduled,
      );
    } else {
      final reward = (res as TaskRefuseResponse).reward;
      final punishment = res.punishment;

      await showRewardPunishmentDialog(
        label: 'Завдання "${task.name}"',
        context: context,
        reward: reward,
        punishment: punishment,
        wasNewQuestScheduled: wasNewQuestScheduled,
      );
    }

    if (quest().isFinished) await sync.syncQuests();
  }
}
