import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/app_route.dart';
import '../../common/enums/sprite.dart';
import '../../data/models/user.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/add_button.dart';
import '../widgets/authorizer.dart';
import '../widgets/currency/currency_balance.dart';
import '../widgets/layouts/desktop.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_bars/labeled_progress_bar.dart';
import '../widgets/progress_indicator_button.dart';
import '../widgets/quests_list.dart';
import '../widgets/sprite_avatar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: LayoutSelector(
        mobileLayoutBuilder: (context) => const _MobileHomepage(),
        desktopLayoutBuilder: (context) => const _DesktopHomepage(),
      ),
    );
  }
}

//TODO add priority: it indicates a color of list item outline
final List<(String name, bool isRepeated, DateTime? deadline)> questsData = [
  ('Нявчитися писати бекенд...', false, DateTime(2023, 05, 24, 23, 59)),
  ('Позайматися', true, DateTime(2023, 05, 24, 18, 0)),
  ('Нявчитися нявати', false, DateTime(2023, 05, 30, 23, 59)),
  ('Помуркотіти коханого :3', false, null),
];

class _MobileHomepage extends StatelessWidget {
  const _MobileHomepage();

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      floatingActionButton: AddButton(onPressed: () => context.push(AppRoute.editQuest.route)),
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
                Expanded(child: QuestsList(items: questsData)),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ProgressIndicatorButton.elevated(
                      onPressed: () async {
                        context.push(AppRoute.allQuests.route);
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

  Widget _buildUserInfoBar() {
    const sprite = Sprite.grayCat;
    const radius = 50.0;

    const trustValue = 10;
    const maxTrust = 100;

    const xpValue = 40;
    const maxXp = 100;
    const xpLevel = 2;

    const nFish = 10;
    const nValerian = 1;

    return Consumer<User?>(
      builder: (context, maybeUser, child) {
        final user = maybeUser!;

        return IntrinsicHeight(
          child: Row(
            children: [
              SpriteAvatar.asset(
                sprite.asset,
                minRadius: radius,
                scale: scaleToFitCircle(radius),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LabeledProgressBar(
                      label: 'Довіра',
                      value: user.trust,
                      maxValue: maxTrust,
                    ),
                    LabeledProgressBar(
                      label: 'XP',
                      value: user.levelExp,
                      maxValue: user.levelCap,
                      progressBarCaption: 'Рівень ${user.level}',
                    ),
                    CurrencyBalance(
                      commonCurrencyBalance: user.feed,
                      rareCurrencyBalance: user.catnip,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DesktopHomepage extends StatelessWidget {
  const _DesktopHomepage();

  @override
  Widget build(BuildContext context) => const DesktopLayout();
}
