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

  Future<void> _processAddSkill({required bool atStart}) async {
    if (!_allSkillsFetched) {
      await _fetchAllSkills();
    }

    if (!mounted || !_allSkillsFetched) return;

    final searchOptions = _allSkills.toList()..removeWhere(_questSkills.contains);

    await showSearch(
      context: context,
      delegate: _SkillsSearchDelegate(
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

class _SkillsSearchDelegate extends SearchDelegate<Skill> {
  final List<Skill> _options;
  final Callback<Skill> _skillSelectedCallback;

  _SkillsSearchDelegate({
    required List<Skill> options,
    required Callback<Skill> skillSelectedCallback,
  })  : _options = options,
        _skillSelectedCallback = skillSelectedCallback;

  @override
  Widget buildSuggestions(BuildContext context) {
    final normalizedQuery = query.toLowerCase();
    final searchResults = _options
        .where((skill) => skill.name.toLowerCase().contains(normalizedQuery))
        .toList(growable: false);

    return ListView.builder(
      itemCount: _options.length,
      itemBuilder: (context, index) {
        final skill = searchResults[index];

        return SkillTile(
          skill,
          onPressed: () {
            context.pop();
            _skillSelectedCallback(skill);
          },
        );
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return const [];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildResults(BuildContext context) => buildSuggestions(context);
}
