import 'package:flutter/material.dart';

import '../../../data/models/skill.dart';
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
      QuestSkillPriority.main => Colors.transparent,
      QuestSkillPriority.secondary => Colors.grey[800],
      QuestSkillPriority.additional => Colors.transparent,
    };

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(4),
      width: dimension,
      height: dimension,
      decoration: skillPriority.decoration.copyWith(
        borderRadius: BorderRadius.circular(defaultBorderRadius.bottomLeft.x * 3),
        color: backgroundColor,
      ),
      child: Center(child: FittedBox(child: Text(skill.name, softWrap: true))),
    );
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
