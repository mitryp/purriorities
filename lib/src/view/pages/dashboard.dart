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
    return MobileLayout(
      children: [
        _buildUserInfoBar(),
      ],
    );
  }

  Widget _buildUserInfoBar() {
    const sprite = Sprite.grayCat;
    const radius = 50.0;
    final scale = (radius - sprite.size.width) * 2;

    return Row(
      children: [
        SpriteAvatar.asset(sprite.asset, minRadius: radius, scale: scaleTo(scale)),
        const Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Text('Довіра', textAlign: TextAlign.end),
                  ),
                  Expanded(
                    flex: 2,
                    child: ProgressBar(
                      maxValue: 100,
                      initialValue: 10,
                      height: 30,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text('XP')),
                  Expanded(
                    flex: 2,
                    child: ProgressBar(
                      maxValue: 1000,
                      initialValue: 600,
                      height: 30,
                      caption: Text('Рівень 1'),
                    ),
                  ),
                ],
              )
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
