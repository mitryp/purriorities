import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    wrapper.data = quest.copyWith(questSkills: skills);
  }
}

const _mainSkillTileBorderSide = BorderSide(color: legendaryColor, width: 3);
const _additionalSkillTileBorderSide = BorderSide(color: Color(0xff424242), width: 3);

enum QuestSkillPriority {
  main(
    BoxDecoration(
      border: Border(
        top: _mainSkillTileBorderSide,
        right: _mainSkillTileBorderSide,
        bottom: _mainSkillTileBorderSide,
        left: _mainSkillTileBorderSide,
      ),
    ),
  ),
  secondary,
  additional(
    BoxDecoration(
      border: Border(
        top: _additionalSkillTileBorderSide,
        right: _additionalSkillTileBorderSide,
        bottom: _additionalSkillTileBorderSide,
        left: _additionalSkillTileBorderSide,
      ),
    ),
  );

  final BoxDecoration decoration;

  const QuestSkillPriority([this.decoration = const BoxDecoration()]);

  factory QuestSkillPriority.fromIndex(int index) {
    if (index == 0) return QuestSkillPriority.main;
    if (index <= 2) return QuestSkillPriority.secondary;

    return QuestSkillPriority.additional;
  }
}
