import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../common/enums/quest_skill_prority.dart';
import '../../../data/models/quest.dart';
import '../../../data/models/skill.dart';
import '../../../data/util/notifier_wrapper.dart';
import '../../dialogs/confirmation_dialog.dart';
import '../../theme.dart';

class QuestSkillTile extends StatelessWidget {
  final Skill skill;
  final QuestSkillPriority skillPriority;
  final double dimension;

  const QuestSkillTile(
    this.skill, {
    required this.skillPriority,
    this.dimension = 100,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = switch (skillPriority) {
      QuestSkillPriority.main || QuestSkillPriority.additional => Colors.transparent,
      QuestSkillPriority.secondary => Colors.grey[800],
    };

    return Stack(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.all(4),
          width: dimension,
          height: dimension,
          decoration: skillPriority.decoration.copyWith(
            borderRadius: BorderRadius.circular(defaultBorderRadius.bottomLeft.x * 3),
            color: backgroundColor,
          ),
          child: Center(
            child: FittedBox(
              child: Text(skill.name, softWrap: true),
            ),
          ),
        ),
        Positioned(
          top: -7,
          right: -2,
          child: IconButton(
            onPressed: () => _removeSkill(context),
            icon: const Icon(Icons.remove),
          ),
        ),
      ],
    );
  }

  void _removeSkill(BuildContext context) async {
    final isConfirmed = await showConfirmationDialog(
      context: context,
      prompt: 'Ви дійсно хочете прибрати цю навичку з квесту?',
      confirmLabelText: 'Так',
      denyLabelText: 'Ні',
    );

    // ignore: use_build_context_synchronously
    if (!context.mounted || !isConfirmed) return;

    final wrapper = context.read<NotifierWrapper<Quest>>();
    final quest = wrapper.data;

    final skills = quest.skills.toList()..remove(skill);
    wrapper.data = quest.copyWith(skills: skills);
  }
}

class DraggableQuestSkillTile extends StatelessWidget {
  static const EdgeInsets _tilePadding = EdgeInsets.all(8);
  static const Offset _handleIconOffset = Offset(-8, -6);

  final int index;
  final Skill skill;
  final bool useDelayedListener;

  const DraggableQuestSkillTile({
    required this.index,
    required this.skill,
    this.useDelayedListener = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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

    return useDelayedListener
        ? ReorderableDelayedDragStartListener(index: index, child: child)
        : ReorderableDragStartListener(index: index, child: child);
  }
}
