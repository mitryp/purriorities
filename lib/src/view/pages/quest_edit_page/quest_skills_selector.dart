part of 'quest_edit_page.dart';

class _QuestSkillsSelector extends StatefulWidget {
  const _QuestSkillsSelector({super.key});

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
    const topPadding = 0.0;
    const titleFontSize = 18.0;
    const leftTitlePadding = 16.0;

    final plusButton = SizedBox.square(
      dimension: 50,
      child: Center(
        child: IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {}, // todo add skill to the quest
        ),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(top: topPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: leftTitlePadding),
            child: Text('Навички', style: TextStyle(fontSize: titleFontSize)),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 100),
            child: Scrollbar(
              interactive: false,
              thickness: 1.5,
              controller: _scrollController,
              thumbVisibility: true,
              child: ReorderableListView(
                header: plusButton,
                footer: _skills.isNotEmpty ? plusButton : null,
                scrollController: _scrollController,
                scrollDirection: Axis.horizontal,
                onReorder: _processSkillsReorder,
                children: _skills
                    .asMap()
                    .entries
                    .map(
                      (e) => Padding(
                        key: ValueKey(e.value.id),
                        padding: const EdgeInsets.all(8),
                        child: QuestSkillTile(
                          e.value,
                          skillPriority: QuestSkillPriority.fromIndex(e.key),
                        ),
                      ),
                    )
                    .toList(growable: false),
              ),
            ),
          ),
        ],
      ),
    );
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

    wrapper.data = quest.copyWithPreserveSchedule(skills: reorderedSkills);

    setState(() => _skills = reorderedSkills);
  }
}
