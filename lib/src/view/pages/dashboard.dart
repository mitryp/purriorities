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

  Widget _buildProgressIndicator({
    required String label,
    required int value,
    required int maxValue,
    int minValue = 0,
    String? progressBarCaption,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(label, textAlign: TextAlign.end),
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
          flex: 3,
          child: ProgressBar(
            minValue: minValue,
            maxValue: maxValue,
            value: value,
            height: 25,
            caption: progressBarCaption != null ? Text(progressBarCaption) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoBar() {
    const sprite = Sprite.grayCat;
    const radius = 50.0;
    final scale = (radius - sprite.size.width) * 2;

    final trustValue = 10;
    final maxTrust = 100;

    final xpValue = 40;
    final maxXp = 100;
    final xpLevel = 2;

    return IntrinsicHeight(
      child: Row(
        children: [
          SpriteAvatar.asset(sprite.asset, minRadius: radius, scale: scaleTo(scale)),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildProgressIndicator(label: 'Довіра', value: trustValue, maxValue: maxTrust),
                _buildProgressIndicator(
                  label: 'XP',
                  value: xpValue,
                  maxValue: maxXp,
                  progressBarCaption: 'Рівень $xpLevel',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopHomepage extends StatelessWidget {
  const _DesktopHomepage({super.key});

  @override
  Widget build(BuildContext context) => const DesktopLayout();
}
