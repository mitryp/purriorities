part of 'quest_edit_page.dart';

class _QuestStagesEditor extends StatefulWidget {
  const _QuestStagesEditor({super.key});

  @override
  State<_QuestStagesEditor> createState() => _QuestStagesEditorState();
}

class _QuestStagesEditorState extends State<_QuestStagesEditor> {
  List<QuestStage> _stages = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stages = context.watch<NotifierWrapper<Quest>>().data.stages.toList();
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      shrinkWrap: true,
      onReorder: _processStagesReorder,
      children: _stages
          .map(
            (e) => _QuestStageEntry(e, key: ValueKey(e.id)),
          )
          .toList(growable: false),
    );
  }

  void _processStagesReorder(int oldIndex, int newIndex) {}
}

class _QuestStageEntry extends StatelessWidget {
  final QuestStage stage;

  const _QuestStageEntry(this.stage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: stage.tasks.map(_StageTaskEntry.new).toList(growable: false),
    );
  }
}

class _StageTaskEntry extends StatelessWidget {
  final Task task;

  const _StageTaskEntry(this.task, {super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: legendaryColor.withOpacity(.5)),
      child: Text(task.name),
    );
  }
}
