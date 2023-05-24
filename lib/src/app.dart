import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'view/pages/login_page.dart';
import 'view/pages/register_page.dart';
import 'view/theme.dart';

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/dashboard', builder: (context, state) => const Placeholder()),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) =>
          RegisterPage(email: state.extra is String ? state.extra as String : null),
    ),
    GoRoute(
      path: '/edit_quest',
      builder: (context, state) => QuestEditPage(
        initialQuest: state.extra is QuestModel ? state.extra as QuestModel : null,
      ),
    )
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
