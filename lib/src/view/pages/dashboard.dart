import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/app_route.dart';
import '../../common/enums/query_param.dart';
import '../../common/enums/sprite.dart';
import '../../data/models/user.dart';
import '../../data/user_data.dart';
import '../../util/extensions/context_synchronizer.dart';
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

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _processPossibleRedirect());
  }

  void _processPossibleRedirect() {
    final redirectPath = QueryParam.redirectTo.valueOf(context);

    if (redirectPath == null || redirectPath == GoRouter.of(context).location) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.push(redirectPath);
    });
  }

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
                      onPressed: () => context
                          .push(AppRoute.allQuests.route)
                          .whenComplete(context.synchronizer().syncQuests),
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

  const _UserInfoSection();

  @override
  Widget build(BuildContext context) {
    const labelFlex = 2;
    const progressBarFlex = 5;

    return Selector<UserData, User>(
      selector: (context, data) => data.user!,
      builder: (context, user, child) {
        return IntrinsicHeight(
          child: Row(
            children: [
              SpriteAvatar.asset(
                sprite.animatedAsset,
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
                      labelFlex: labelFlex,
                      progressBarFlex: progressBarFlex,
                    ),
                    LabeledProgressBar(
                      label: 'Досвід',
                      value: user.levelExp,
                      maxValue: user.levelCap,
                      progressBarCaption: 'Рівень ${user.level}',
                      labelFlex: labelFlex,
                      progressBarFlex: progressBarFlex,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Expanded(
                            flex: labelFlex,
                            child: SizedBox(),
                          ),
                          Expanded(
                            flex: progressBarFlex,
                            child: CurrencyBalance(
                              commonCurrencyBalance: user.feed,
                              rareCurrencyBalance: user.catnip,
                            ),
                          ),
                        ],
                      ),
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
