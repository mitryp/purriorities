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
        desktopLayoutBuilder: (context) => const Placeholder(),
      ),
    );
  }
}

class _MobileNavigation extends StatelessWidget {
  final Widget child;

  const _MobileNavigation({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigator(context),
      body: child,
    );
  }

  Widget _buildBottomNavigator(BuildContext context) {
    const actions = MainNavAction.values;

    final data = context.watch<MainNavigationData>();

    return BottomNavigationBar(
      unselectedItemColor: Colors.white,
      selectedItemColor: QuestPriority.legendary.color,
      onTap: (index) => GoRouter.of(context).go(actions[index].route.route),
      currentIndex: data.index,
      items: actions.map((action) {
        return BottomNavigationBarItem(
          icon: Icon(action.iconData, size: 36),
          label: action.label,
          //TODO background color
        );
      }).toList(),
    );
  }
}
