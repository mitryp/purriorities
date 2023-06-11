import 'package:flutter/material.dart';

import '../../data/models/skill.dart';
import '../theme.dart';
import 'progress_bars/progress_bar.dart';

class SkillTile extends StatelessWidget {
  final Skill skill;
  final double height;
  final VoidCallback? onPressed;

  const SkillTile(
    this.skill, {
    this.height = 50.0,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final onPressed = this.onPressed;

    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ProgressBar(
            height: height,
            overlayingWidget: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(skill.name, style: progressBarCaptionTextStyle),
                  Text('Рівень ${skill.level}', style: progressBarCaptionTextStyle),
                ],
              ),
            ),
            value: skill.levelExp,
            maxValue: skill.levelCap,
          ),
        ),
      ),
    );
  }
}
