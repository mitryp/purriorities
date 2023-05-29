import 'package:flutter/material.dart';

import '../widgets/add_button.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_bars/progress_bar.dart';

const List<({String name, int level, int progress, int maxProgress})> skills = [
  (name: 'Нявання', level: 100, progress: 10, maxProgress: 100),
  (name: 'Програмування', level: 10, progress: 60, maxProgress: 100),
  (name: 'Тайм-менеджмент', level: 0, progress: 0, maxProgress: 100),
];

class SkillsPage extends StatelessWidget {
  const SkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutSelector(
      mobileLayoutBuilder: (context) => const _MobileSkillsPage(),
      desktopLayoutBuilder: (context) => const Placeholder(),
    );
  }
}

class _MobileSkillsPage extends StatelessWidget {
  const _MobileSkillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      //TODO onPressed => form for creating new skill
      floatingActionButton: AddButton(onPressed: () {}),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      children: skills.map((skill) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: ProgressBar(
              height: 50,
              overlayingWidget: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(skill.name),
                    Text('Рівень ${skill.level}')
                  ],
                ),
              ),
              value: skill.progress,
              maxValue: skill.maxProgress,
            ),
          ),
        );
      }).toList(),
    );
  }
}
