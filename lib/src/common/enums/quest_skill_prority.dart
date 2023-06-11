import 'package:flutter/widgets.dart';

import '../../view/theme.dart';

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
