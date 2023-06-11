part of 'quest_edit_page.dart';

class _QuestSkillsSelector extends StatefulWidget {
  const _QuestSkillsSelector();

  @override
  State<_QuestSkillsSelector> createState() => _QuestSkillsSelectorState();
}

class _QuestSkillsSelectorState extends State<_QuestSkillsSelector> {
  final _scrollController = ScrollController();

  final List<Skill> _allSkills = [];
  bool _allSkillsFetched = false;

  List<Skill> _questSkills = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _questSkills = context.watch<NotifierWrapper<Quest>>().data.skills.toList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchAllSkills() async {
    final fetchService = context.read<FetchServiceBundle>().skillsFetchService;

    final skillsRes = await fetchService.getMany();

    if (!mounted) return;

    if (!skillsRes.isSuccessful) {
      showErrorSnackBar(
        context: context,
        content: ErrorSnackBarContent(
          titleText: 'Не вдалось отримати список навичок',
          subtitleText: 'Повідомлення від сервера: ${skillsRes.errorMessage}',
        ),
      );

      return;
    }

    _allSkills.addAll(skillsRes.result().data);
    _allSkillsFetched = true;
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
            maxHeight: _questSkills.isNotEmpty ? skillsBoxHeight : emptySkillsBoxHeight,
          ),
          child: Scrollbar(
            interactive: false,
            thickness: scrollbarThickness,
            controller: _scrollController,
            child: ReorderableListView.builder(
              buildDefaultDragHandles: false,
              // todo add skill to the quest
              header: _AddSkillButton(onPressed: () => _processAddSkill(atStart: true)),
              footer: _questSkills.isNotEmpty
                  ? _AddSkillButton(onPressed: () => _processAddSkill(atStart: false))
                  : null,
              scrollController: _scrollController,
              scrollDirection: Axis.horizontal,
              onReorder: _processSkillsReorder,
              itemCount: _questSkills.isNotEmpty ? _questSkills.length : 1,
              itemBuilder: (context, index) {
                if (_questSkills.isEmpty) {
                  return const Center(
                    key: ValueKey('no-skills-text'),
                    child: Text('Ви можете додати навички до квесту'),
                  );
                }

                final skill = _questSkills[index];

                return DraggableQuestSkillTile(
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

  Future<void> _processAddSkill({required bool atStart}) async {
    if (!_allSkillsFetched) {
      await _fetchAllSkills();
    }

    if (!mounted || !_allSkillsFetched) return;

    final searchOptions = _allSkills.toList()..removeWhere(_questSkills.contains);

    await showSearch(
      context: context,
      delegate: SkillsSearchDelegate(
        options: searchOptions,
        skillSelectedCallback: (skill) {
          if (!mounted) return;

          setState(() => _questSkills.insert(atStart ? 0 : _questSkills.length, skill));
          final wrapper = context.read<NotifierWrapper<Quest>>();
          wrapper.data = wrapper.data.copyWith(skills: _questSkills);
        },
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

    wrapper.data = quest.copyWith(skills: reorderedSkills);

    setState(() => _questSkills = reorderedSkills);
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
