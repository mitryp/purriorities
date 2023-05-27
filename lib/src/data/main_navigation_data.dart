import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../common/enums/app_route.dart';
import '../view/pages/collection_page.dart';
import '../view/pages/dashboard.dart';
import '../view/pages/skills_page.dart';
import '../view/pages/store_page.dart';

class MainNavigationData with ChangeNotifier {
  MainNavAction _action = MainNavAction.dashboard;

  MainNavAction get currentPage => _action;

  set currentPage(MainNavAction value) {
    _action = value;
    notifyListeners();
  }

  int get index => currentPage.index;

  MainNavigationData();

  factory MainNavigationData.of(BuildContext context) => context.read<MainNavigationData>();
}

enum MainNavAction {
  dashboard(Icons.home_outlined, 'Головна', AppRoute.dashboard, _dashboardBuilder),
  skills(Icons.psychology_outlined, 'Навички', AppRoute.skills, _skillsBuilder),
  cats(Icons.pets_outlined, 'Котики', AppRoute.cats, _catsBuilder),
  store(Icons.storefront_outlined, 'Магазин', AppRoute.store, _storeBuilder);

  final IconData iconData;
  final String label;
  final AppRoute route;
  final WidgetBuilder builder;

  const MainNavAction(this.iconData, this.label, this.route, this.builder);

  Widget goRouterWidgetBuilder(BuildContext context, GoRouterState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;

      MainNavigationData.of(context).currentPage = this;
    });

    return builder(context);
  }
}

Widget _dashboardBuilder(BuildContext context) => const Dashboard();

Widget _skillsBuilder(BuildContext context) => const SkillsPage();

Widget _catsBuilder(BuildContext context) => const CollectionPage();

Widget _storeBuilder(BuildContext context) => const StorePage();
