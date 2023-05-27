import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'view/pages/collection_page.dart';
import 'view/pages/quest_edit_page.dart';

import 'common/enums/routes.dart';
import 'view/pages/dashboard.dart';
import 'view/pages/login_page.dart';
import 'view/pages/quests_page.dart';
import 'view/pages/register_page.dart';
import 'view/pages/skills_page.dart';
import 'view/theme.dart';
import 'view/widgets/main_navigation.dart';

final _router = GoRouter(
  initialLocation: Routes.dashboard.route,
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainNavigation(child: child),
      routes: [
        GoRoute(
          path: Routes.dashboard.route,
          builder: (context, state) => const Dashboard(),
        ),
        GoRoute(
          path: Routes.cats.route,
          builder: (context, state) => const CollectionPage(),
        ),
        GoRoute(
          path: Routes.store.route,
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: Routes.skills.route,
          builder: (context, state) => const SkillsPage(),
        ),
      ],
    ),
    GoRoute(
      path: Routes.login.route,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: Routes.register.route,
      builder: (context, state) => RegisterPage(
        email: state.extra is String ? state.extra as String : null,
      ),
    ),
    GoRoute(
      path: Routes.editQuest.route,
      builder: (context, state) =>
          QuestEditPage(
        //initialQuest: state.extra is QuestModel ? state.extra as QuestModel : null,
        initialQuest: null,
      ),
    ),
    GoRoute(
      path: Routes.allQuests.route,
      builder: (context, state) => const QuestsPage(),
    ),
  ],
);

class PurrioritiesApp extends StatelessWidget {
  const PurrioritiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: darkTheme,
      //
      routerConfig: _router,
    );
  }
}
