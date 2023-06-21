import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/enums/quest_priority.dart';
import '../../data/main_navigation_data.dart';
import 'layouts/layout_selector.dart';

class MainNavigation extends StatelessWidget {
  final Widget child;

  const MainNavigation({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainNavigationData(),
      child: LayoutSelector(
        mobileLayoutBuilder: (context) => _MobileNavigation(child: child),
      ),
    );
  }
}

class _MobileNavigation extends StatelessWidget {
  final Widget child;

  const _MobileNavigation({required this.child});

  @override
  Widget build(BuildContext context) {
    const actions = MainNavAction.values;
    final currentLocation = GoRouter.of(context).location;
    final currentAction = MainNavAction.values.firstWhere(
      (action) => action.route.route == currentLocation,
      orElse: () => MainNavAction.dashboard,
    );

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.white,
        selectedItemColor: QuestPriority.legendary.color,
        onTap: (index) => GoRouter.of(context).go(actions[index].route.route),
        currentIndex: currentAction.index,
        items: actions.map((action) {
          return BottomNavigationBarItem(
            icon: Icon(action.iconData, size: 36),
            label: action.label,
          );
        }).toList(growable: false),
      ),
      body: child,
    );
  }
}
