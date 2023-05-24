import 'package:flutter/material.dart';

import '../../data/enums/sprite.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/layouts/desktop.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_bar.dart';
import '../widgets/sprite_avatar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutSelector(
      mobileLayoutBuilder: (context) => const _MobileHomepage(),
      desktopLayoutBuilder: (context) => const _DesktopHomepage(),
    );
  }
}

class _MobileHomepage extends StatelessWidget {
  const _MobileHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileLayout.child(
      child: Column(children: [
        buildUserInfoBar(),
      ]),
    );
  }

  Widget buildUserInfoBar() {
    const sprite = Sprite.grayCat;
    const radius = 50.0;
    final scale = (radius - sprite.size.width) * 2;

    return Row(
      children: [
        SpriteAvatar.asset(sprite.asset, minRadius: radius, scale: scaleTo(scale)),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Довіра'),
                  FractionallySizedBox(
                    widthFactor: 0.3,
                    child: ProgressBar(
                      maxValue: 100,
                      initialValue: 10,
                      height: 30,
                    ),
                  ),
                ],
              ),
              // Row(
              //   children: [
              //     const Text('XP'),
              //     ProgressBar(
              //       maxValue: 1000,
              //       initialValue: 600,
              //       height: 30,
              //       caption: const Text('Рівень 1'),
              //     ),
              //   ],
              // )
            ],
          ),
        ),
      ],
    );
  }
}

class _DesktopHomepage extends StatelessWidget {
  const _DesktopHomepage({super.key});

  @override
  Widget build(BuildContext context) => const DesktopLayout();
}
