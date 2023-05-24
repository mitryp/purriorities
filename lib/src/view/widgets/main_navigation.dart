import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'layouts/layout_selector.dart';
import 'layouts/mobile.dart';

enum MainNavAction {
  dashboard(Icons.home_outlined, 'Головна', '/dashboard'),
  cats(Icons.pets_outlined, 'Котики', '/cats'),
  shop(Icons.storefront_outlined, 'Магазин', '/store');

  final IconData iconData;
  final String label;
  final String link;

  const MainNavAction(this.iconData, this.label, this.link);
}

class MainNavigation extends StatefulWidget {
  final Widget child;

  const MainNavigation({required this.child, super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return LayoutSelector(
      mobileLayoutBuilder: (context) =>
          MobileLayout.child(bottomNavigationBar: _buildBottomNavigator(), child: widget.child),
      desktopLayoutBuilder: (context) => const Placeholder(),
    );
  }

  Widget _buildBottomNavigator() {
    const actions = MainNavAction.values;

    return BottomNavigationBar(
      onTap: (index) => setState(() {
        selectedIndex = index;
        GoRouter.of(context).go(actions[index].link);
      }),
      currentIndex: selectedIndex,
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
