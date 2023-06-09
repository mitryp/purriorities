import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../common/enums/app_route.dart';
import '../../common/enums/query_param.dart';
import '../../common/enums/sprite.dart';
import '../../data/models/user.dart';
import '../../data/user_data.dart';
import '../../services/punishment_service.dart';
import '../../util/extensions/context_synchronizer.dart';
import '../../util/sprite_scaling.dart';
import '../widgets/active_quests_view.dart';
import '../widgets/add_button.dart';
import '../widgets/authorizer.dart';
import '../widgets/currency/currency_balance.dart';
import '../widgets/layouts/layout_selector.dart';
import '../widgets/layouts/mobile.dart';
import '../widgets/progress_bars/labeled_progress_bar.dart';
import '../widgets/punishment_consumer.dart';
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
      child: PunishmentConsumer(
        child: LayoutSelector(
          mobileLayoutBuilder: (context) => const _MobileDashboard(),
        ),
      ),
    );
  }
}

class _MobileDashboard extends StatelessWidget {
  const _MobileDashboard();

  @override
  Widget build(BuildContext context) {
    final punishmentService = context.read<PunishmentTimerService>();

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
                      onPressed: () => context.push(AppRoute.allQuests.route).whenComplete(
                            () => context
                                .synchronizer()
                                .syncQuests()
                                .whenComplete(punishmentService.reschedulePunishmentSync),
                          ),
                      child: const Text('Всі квести'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // const SizedBox(height: 40.0),
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
    const progressBarFlex = 5;

    return Selector<UserData, User>(
      selector: (context, data) => data.user!,
      builder: (context, user, child) {
        return IntrinsicHeight(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: radius * 2 * 1.3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () => context.push(AppRoute.profile.route),
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: SpriteAvatar.asset(
                            sprite.animatedAsset,
                            minRadius: radius,
                            scale: scaleToFitCircle(radius),
                          ),
                        ),
                      ),
                      Text(user.nickname),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LabeledProgressBar(
                      label: 'Довіра',
                      value: user.trust,
                      maxValue: maxTrust,
                      progressBarFlex: progressBarFlex,
                    ),
                    LabeledProgressBar(
                      label: 'Досвід',
                      value: user.levelExp,
                      maxValue: user.levelCap,
                      progressBarCaption: 'Рівень ${user.level}',
                      progressBarFlex: progressBarFlex,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Text('     '),
                          const SizedBox(width: 8),
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
