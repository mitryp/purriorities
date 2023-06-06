import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/app_route.dart';
import '../../common/enums/sprite.dart';
import '../../data/models/user.dart';
import '../../data/user_data.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/active_quests_view.dart';
import '../widgets/add_button.dart';
import '../widgets/authorizer.dart';
import '../widgets/currency/currency_balance.dart';
import '../widgets/layouts/desktop.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_bars/labeled_progress_bar.dart';
import '../widgets/sprite_avatar.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Authorizer(
      child: LayoutSelector(
        mobileLayoutBuilder: (context) => const _MobileDashboard(),
        desktopLayoutBuilder: (context) => const _DesktopDashboard(),
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

class _MobileDashboard extends StatelessWidget {
  const _MobileDashboard();

  @override
  Widget build(BuildContext context) {
    return MobileLayout(
      floatingActionButton: AddButton(onPressed: () => context.push(AppRoute.editQuest.route)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 14.0, horizontal: 8.0),
          child: _UserInfoSection(),
        ),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Не втратьте довіру: виконайте квести!',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Expanded(child: ActiveQuestsView()),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () async => context.push(AppRoute.allQuests.route),
                      child: const Text('Всі квести'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 40.0),
      ],
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  static const Sprite sprite = Sprite.grayCat;
  static const double radius = 50.0;
  static const int maxTrust = 100;

  const _UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<UserData, User>(
      selector: (context, data) => data.user!,
      builder: (context, user, child) {
        return IntrinsicHeight(
          child: Row(
            children: [
              SpriteAvatar.asset(
                sprite.asset,
                minRadius: radius,
                scale: scaleToFitCircle(radius),
              ),
              const SizedBox(width: 8),
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

class _DesktopDashboard extends StatelessWidget {
  const _DesktopDashboard();

  @override
  Widget build(BuildContext context) => const DesktopLayout();
}
