import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  const AppShell({super.key, required this.shell});

  static const tabs = <_NavTab>[
    _NavTab(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
    _NavTab(
      icon: Icons.people_alt_outlined,
      activeIcon: Icons.people_alt,
      label: 'Community',
    ),
    _NavTab(
      icon: Icons.event_outlined,
      activeIcon: Icons.event,
      label: 'Events',
    ),
    _NavTab(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'Chat',
    ),
    _NavTab(
      icon: Icons.menu_outlined,
      activeIcon: Icons.menu,
      label: 'More',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
        destinations: [
          for (final t in tabs)
            NavigationDestination(
              icon: Icon(t.icon),
              selectedIcon: Icon(t.activeIcon),
              label: t.label,
            ),
        ],
      ),
    );
  }
}

class _NavTab {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
