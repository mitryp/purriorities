import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'common/enums/app_route.dart';
import 'data/main_navigation_data.dart';
import 'data/models/quest.dart';
import 'data/models/skill.dart';
import 'data/user_data.dart';
import 'services/cats_info_cache.dart';
import 'services/http/auth_service.dart';
import 'services/http/util/client.dart';
import 'services/http/util/fetch_service_bundle.dart';
import 'services/synchronizer.dart';
import 'typedefs.dart';
import 'view/pages/init_page.dart';
import 'view/pages/login_page.dart';
import 'view/pages/quest_edit_page/quest_edit_page.dart';
import 'view/pages/quests_page/quests_page.dart';
import 'view/pages/register_page.dart';
import 'view/pages/skills_edit_page.dart';
import 'view/theme.dart';
import 'view/widgets/main_navigation.dart';

final _router = GoRouter(
  initialLocation: AppRoute.init.route,
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
      path: AppRoute.init.route,
      builder: (context, state) {
        final extra = state.extra;

        return InitPage(
          sessionRestored: extra is SessionRestorationExtra ? extra.sessionRestored : false,
        );
      },
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
      path: AppRoute.allQuests.route,
      builder: (context, state) => const QuestsPage(),
    ),
    GoRoute(
      path: AppRoute.editQuest.route,
      builder: (context, state) => QuestEditPage(
        initialQuest: state.extra is Quest ? state.extra as Quest : null,
      ),
    ),
    GoRoute(
      path: AppRoute.editSkill.route,
      builder: (context, state) => SkillsEditPage(
        skill: state.extra is Skill ? state.extra as Skill : null,
      ),
    )
  ],
);

class PurrioritiesApp extends StatelessWidget {
  const PurrioritiesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _AppTopProviders(
      child: MaterialApp.router(
        title: 'Purriorities',
        debugShowCheckedModeBanner: false,
        theme: darkTheme,
        //
        routerConfig: _router,
      ),
    );
  }
}

/// A widget holding a layer of top-level providers of this application.
class _AppTopProviders extends StatelessWidget {
  final Widget child;

  const _AppTopProviders({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // an HTTP client singleton provider
        Provider<Dio>(
          create: (_) => createHttpClient(),
        ),

        // a UserData provider with a change notifier wrapper
        ChangeNotifierProvider<UserData>(
          create: (_) => UserData(),
        ),

        // an AuthService singleton provider dependant on the HTTP client
        ProxyProvider<Dio, AuthService>(
          update: (_, client, prev) => prev ?? AuthService(client),
        ),

        // a provider of all the fetch services singletons. depends on the HTTP client
        ProxyProvider<Dio, FetchServiceBundle>(
          update: (_, client, prev) => prev ?? bundleFetchServices(client),
        ),

        // a CatsInfoCache singleton provider. depends on the fetch services bundle
        ProxyProvider<FetchServiceBundle, CatsInfoCache>(
          update: (_, bundle, prev) => prev ?? CatsInfoCache(bundle.catsFetchService),
        ),

        // a Synchronizer provider
        Provider<Synchronizer>(create: Synchronizer.new),
      ],
      child: child,
    );
  }
}
