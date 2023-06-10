part of 'quest_edit_page.dart';

class _QuestSkillsSelector extends StatefulWidget {
  const _QuestSkillsSelector();

  @override
  State<_QuestSkillsSelector> createState() => _QuestSkillsSelectorState();
}

class _QuestSkillsSelectorState extends State<_QuestSkillsSelector> {
  final _scrollController = ScrollController();

  List<Skill> _skills = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _skills = context.watch<NotifierWrapper<Quest>>().data.skills.toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const titleFontSize = 18.0;
    const leftTitlePadding = 16.0;
    const bottomTitlePadding = 8.0;
    const scrollbarThickness = 0.5;
    const skillsBoxHeight = 100.0;
    const emptySkillsBoxHeight = 75.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: leftTitlePadding, bottom: bottomTitlePadding),
          child: Text('Навички', style: TextStyle(fontSize: titleFontSize)),
        ),
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: _skills.isNotEmpty ? skillsBoxHeight : emptySkillsBoxHeight,
          ),
          child: Scrollbar(
            interactive: false,
            thickness: scrollbarThickness,
            controller: _scrollController,
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              // todo add skill to the quest
              header: _AddSkillButton(onPressed: () => _processAddSkill(atStart: true)),
              footer: _skills.isNotEmpty
                  ? _AddSkillButton(onPressed: () => _processAddSkill(atStart: false))
                  : null,
              scrollController: _scrollController,
              scrollDirection: Axis.horizontal,
              onReorder: _processSkillsReorder,
              itemCount: _skills.isNotEmpty ? _skills.length : 1,
              itemBuilder: (context, index) {
                if (_skills.isEmpty) {
                  return const Center(
                    key: ValueKey('no-skills-text'),
                    child: Text('Ви можете додати навички до квесту'),
                  );
                }

                final skill = _skills[index];

                return _DraggableSkillTile(
                  index: index,
                  skill: skill,
                  useDelayedListener: true,
                  key: ValueKey(skill.id),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void _processAddSkill({required bool atStart}) {
    // todo
  }

  void _processSkillsReorder(int oldIndex, int newIndex) {
    final wrapper = context.read<NotifierWrapper<Quest>>();
    final quest = wrapper.data;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final skills = quest.skills;
    final draggedSkill = skills[oldIndex];
    final reorderedSkills = skills.toList()
      ..removeAt(oldIndex)
      ..insert(newIndex, draggedSkill);

    wrapper.data = quest.copyWith(questSkills: reorderedSkills);

    setState(() => _skills = reorderedSkills);
  }
}

class _AddSkillButton extends StatelessWidget {
  static const double _dimension = 50.0;

  final VoidCallback onPressed;

  const _AddSkillButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _dimension,
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

class _DraggableSkillTile extends StatelessWidget {
  static const EdgeInsets _tilePadding = EdgeInsets.all(8);
  static const Offset _handleIconOffset = Offset(-8, -6);

  final int index;
  final Skill skill;
  final bool useDelayedListener;

  const _DraggableSkillTile({
    required this.index,
    required this.skill,
    this.useDelayedListener = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // final listenerConstructor = useDelayedListener
    //     ? ReorderableDelayedDragStartListener.new
    //     : ReorderableDragStartListener.new;

    final child = Padding(
      padding: _tilePadding,
      child: Badge(
        offset: _handleIconOffset,
        backgroundColor: Colors.transparent,
        alignment: Alignment.bottomCenter,
        label: const Icon(Icons.drag_handle),
        child: QuestSkillTile(
          skill,
          skillPriority: QuestSkillPriority.fromIndex(index),
        ),
      ),
    );

    if (useDelayedListener) {
      return ReorderableDelayedDragStartListener(
        index: index,
        child: child,
      );
    }

    return ReorderableDragStartListener(
      index: index,
      child: child,
    );
  }
}
