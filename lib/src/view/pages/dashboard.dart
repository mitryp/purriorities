import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/enums/sprite.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/layouts/desktop.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_bar.dart';
import '../widgets/progress_indicator_button.dart';
import '../widgets/quest_tile.dart';
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
      floatingActionButton: _buildFloatingActionButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 20.0),
          child: _buildUserInfoBar(),
        ),
        Expanded(
          child: Card(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text(
                    'Не втратьте довіру: виконайте квести!',
                    style: TextStyle(fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                ),
                _buildQuestsList(context),
                Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ProgressIndicatorButton.elevated(
                      onPressed: () async {
                        GoRouter.of(context).go('/all_quests');
                        //TODO remove
                        await Future.delayed(const Duration(seconds: 1));
                      },
                      child: const Text('Всі квести'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 40.0),
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => GoRouter.of(context).go('/new_quest'),
      shape: const CircleBorder(),
      child: const Icon(Icons.add),
    );
  }

  Widget _buildQuestsList(BuildContext context) {
    //TODO add priority: it indicates a color of list item outline
    final List<(String name, bool isRepeated, DateTime? deadline)> questsData = [
      ('Нявчитися писати бекенд...', false, DateTime(2023, 05, 24, 23, 59)),
      ('Позайматися', true, DateTime(2023, 05, 24, 18, 0)),
      ('Нявчитися нявати', false, DateTime(2023, 05, 30, 23, 59)),
      ('Помуркотіти коханого :3', false, null),
    ];

    return ListView.separated(
      shrinkWrap: true,
      itemCount: questsData.length,
      itemBuilder: (context, index) {
        final (questName, isRepeated, deadline) = questsData[index];

        return QuestTile(questName: questName, isRepeated: isRepeated, deadline: deadline);
      },
      separatorBuilder: (context, index) => const Divider(),
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

  Widget _buildCurrencyStats({required int quantity, required String asset}) {
    return Row(
      children: [
        Text('$quantity'),
        Image.asset(
          asset,
          scale: scaleTo(25),
          filterQuality: FilterQuality.none,
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

    final nFish = 10;
    final nValerian = 1;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildCurrencyStats(quantity: nFish, asset: Sprite.fishFood.asset),
                    const SizedBox(width: 20),
                    _buildCurrencyStats(quantity: nValerian, asset: Sprite.valerian.asset),
                  ],
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
