// lib/shared/screens/shell_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme.dart';
import '../../app/router.dart';

class ShellScreen extends ConsumerWidget {
  const ShellScreen({super.key, required this.child});

  final Widget child;

  static const _tabs = [
    _Tab(route: Routes.home,     icon: '🏠', label: 'Home'),
    _Tab(route: Routes.calendar, icon: '📅', label: 'Calendar'),
    _Tab(route: Routes.habits,   icon: '⭐', label: 'Habits'),
    _Tab(route: Routes.goals,    icon: '🎯', label: 'Goals'),
    _Tab(route: Routes.more,     icon: '✨', label: 'More'),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].route)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = _selectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: BloomColors.cloud)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 12,
              offset: Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 62,
            child: Row(
              children: List.generate(_tabs.length, (i) {
                final tab = _tabs[i];
                final active = i == selected;
                return Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      if (!active) context.go(tab.route);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Indicator dot above active tab
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: active ? 24 : 0,
                            height: 3,
                            margin: const EdgeInsets.only(bottom: 4),
                            decoration: BoxDecoration(
                              color: active ? BloomColors.bloom : Colors.transparent,
                              borderRadius: BorderRadius.all(BloomRadius.pill),
                            ),
                          ),
                          Text(
                            tab.icon,
                            style: TextStyle(
                              fontSize: 22,
                              // Slight scale effect on active
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tab.label,
                            style: TextStyle(
                              fontFamily: BloomFonts.body,
                              fontSize: 9,
                              fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                              color: active ? BloomColors.bloom : BloomColors.stone,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab {
  const _Tab({required this.route, required this.icon, required this.label});
  final String route;
  final String icon;
  final String label;
}
