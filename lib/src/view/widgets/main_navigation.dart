import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/main_navigation_data.dart';
import 'layouts/layout_selector.dart';

enum MainNavAction {
  dashboard(Icons.home_outlined, 'Головна', '/dashboard'),
  cats(Icons.pets_outlined, 'Котики', '/cats'),
  shop(Icons.storefront_outlined, 'Магазин', '/store');

  final IconData iconData;
  final String label;
  final String link;

  const MainNavAction(this.iconData, this.label, this.link);
}

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
      onTap: (index) {
        data.index = index;
        GoRouter.of(context).go(actions[index].link);
      },
      currentIndex: data.index,
      //TODO selected item color
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
