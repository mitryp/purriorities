part of 'quest_edit_page.dart';

class _QuestStagesEditor extends StatefulWidget {
  const _QuestStagesEditor();

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
    final wrapper = context.watch<NotifierWrapper<Quest>>();

    return ReorderableListView(
      shrinkWrap: true,
      buildDefaultDragHandles: false,
      physics: const NeverScrollableScrollPhysics(),
      onReorder: _processStagesReorder,
      footer: OutlinedButton.icon(
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Додати етап'),
        onPressed: () {},
      ),
      children: _stages
          .asMap()
          .entries
          .map(
            (e) => _QuestStageEntry(
              e.value,
              index: e.key,
              wrapper: wrapper,
              key: ValueKey(e.value.id),
            ),
          )
          .toList(growable: false),
    );
  }

  void _processStagesReorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    final movedStage = _stages.removeAt(oldIndex);
    setState(() => _stages.insert(newIndex, movedStage));

    final data = context.read<NotifierWrapper<Quest>>();
    data.data = data.data.copyWith(stages: _stages);
  }
}

class _QuestStageEntry extends StatelessWidget {
  static const double _handlePaddingValue = 13.0;
  static const EdgeInsets _handlePadding = EdgeInsets.only(
    top: _handlePaddingValue,
    right: _handlePaddingValue,
    bottom: _handlePaddingValue,
    left: 0,
  );
  static const double _wrapSpacing = 8;

  final NotifierWrapper<Quest> wrapper;
  final QuestStage stage;
  final int index;

  const _QuestStageEntry(
    this.stage, {
    required this.index,
    required this.wrapper,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ReorderableDragStartListener(
          index: index,
          child: const Padding(
            padding: _handlePadding,
            child: Icon(Icons.drag_indicator),
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: _wrapSpacing),
                child: TextFormField(
                  initialValue: stage.name,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                  onChanged: (value) => _processStageNameChange(context, value),
                ),
              ),
              Wrap(
                spacing: _wrapSpacing,
                runSpacing: _wrapSpacing,
                alignment: WrapAlignment.start,
                children: stage.tasks
                    .map(
                      (e) => _StageTaskEntry(
                        e,
                        wrapper: wrapper,
                      ),
                    )
                    .toList(growable: false),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: _wrapSpacing),
                child: _StageTaskTile(
                  padding: EdgeInsets.zero,
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => _processAddTask(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _processStageNameChange(BuildContext context, String value) {
    final wrapper = context.read<NotifierWrapper<Quest>>();

    final quest = wrapper.data;
    final name = value.trim();
    final stages = quest.stages.toList();
    final index = stages.indexWhere((s) => s.id == stage.id);

    stages
      ..removeAt(index)
      ..insert(index, stage.copyWith(name: name));

    wrapper.data = quest.copyWith(stages: stages);
  }

  Future<void> _processAddTask(BuildContext context) async {
    final taskId = stage.tasks.length;
    final stageId = stage.id;

    await showDialog(
      context: context,
      builder: (context) => TaskEditDialog(
        questNotifier: wrapper,
        task: Task.empty(stageId: stageId, id: 'new-$taskId'),
        isEditing: false,
      ),
    );
  }
}

class _StageTaskTile extends StatelessWidget {
  static final BorderRadius _borderRadius = BorderRadius.circular(8);

  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const _StageTaskTile({
    required this.child,
    this.padding = const EdgeInsets.all(8),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: _borderRadius,
      color: Colors.grey[800],
      child: InkWell(
        borderRadius: _borderRadius,
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class _StageTaskEntry extends StatelessWidget {
  final NotifierWrapper<Quest> wrapper;
  final Task task;

  const _StageTaskEntry(this.task, {required this.wrapper, super.key});

  @override
  Widget build(BuildContext context) {
    return _StageTaskTile(
      onTap: () => _showEditPopup(context),
      child: Text(
        task.name,
        softWrap: true,
        style: const TextStyle(
          fontSize: 15,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  Future<void> _showEditPopup(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => TaskEditDialog(
        questNotifier: wrapper,
        task: task,
        isEditing: true,
      ),
    );
  }
}
