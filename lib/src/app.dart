import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'view/pages/quest_edit_page.dart';

import 'view/pages/dashboard.dart';
import 'view/pages/login_page.dart';
import 'view/pages/quests_page.dart';
import 'view/pages/register_page.dart';
import 'view/pages/skills_page.dart';
import 'view/theme.dart';
import 'view/widgets/main_navigation.dart';

final _router = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainNavigation(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const Dashboard(),
        ),
        GoRoute(
          path: '/cats',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: '/store',
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: '/skills',
          builder: (context, state) => const SkillsPage(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterPage(
        email: state.extra is String ? state.extra as String : null,
      ),
    ),
    GoRoute(
      path: '/edit_quest',
      builder: (context, state) =>
          QuestEditPage(
        //initialQuest: state.extra is QuestModel ? state.extra as QuestModel : null,
        initialQuest: null,
      ),
    ),
    GoRoute(
      path: '/all_quests',
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
