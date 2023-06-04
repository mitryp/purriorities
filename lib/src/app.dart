import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/enums/app_route.dart';
import 'data/main_navigation_data.dart';
import 'data/models/quest.dart';
import 'services/http/client.dart';
import 'view/pages/login_page.dart';
import 'view/pages/quest_edit_page/quest_edit_page.dart';
import 'view/pages/quests_page.dart';
import 'view/pages/register_page.dart';
import 'view/theme.dart';
import 'view/widgets/main_navigation.dart';

final _router = GoRouter(
  initialLocation: AppRoute.dashboard.route,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainNavigation(child: child),
      routes: [
        for (final action in MainNavAction.values)
          GoRoute(
            path: action.route.route,
            builder: action.goRouterWidgetBuilder,
          )
      ],
    ),
    GoRoute(
      path: AppRoute.login.route,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoute.register.route,
      builder: (context, state) => RegisterPage(
        email: state.extra is String ? state.extra as String : null,
      ),
    ),
    GoRoute(
      path: AppRoute.editQuest.route,
      builder: (context, state) => QuestEditPage(
        initialQuest: state.extra is Quest ? state.extra as Quest : null,
      ),
    ),
    GoRoute(
      path: AppRoute.allQuests.route,
      builder: (context, state) => const QuestsPage(),
    ),
  ],
);

class PurrioritiesApp extends StatelessWidget {
  const PurrioritiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Dio>(
          create: (context) => createHttpClient(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
        //
        routerConfig: _router,
      ),
    );
  }
}
