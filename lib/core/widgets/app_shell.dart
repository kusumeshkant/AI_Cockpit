// Top-level navigation shell: bottom nav below Breakpoints.medium, left rail
// at and above it (design: TabletFeed.dc.html / TabletSettings.dc.html).
import 'package:flutter/material.dart';

import 'package:cockpit/core/responsive/breakpoints.dart';
import 'package:cockpit/core/responsive/responsive_builder.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_navigation.dart';

/// Wraps top-level destinations with primary navigation.
class AppShell extends StatelessWidget {
  /// Creates the shell.
  const AppShell({
    required this.items,
    required this.currentIndex,
    required this.onSelected,
    required this.brandName,
    required this.child,
    super.key,
  });

  /// Destinations.
  final List<AppNavItem> items;

  /// Active destination.
  final int currentIndex;

  /// Called with the tapped destination index.
  final ValueChanged<int> onSelected;

  /// Localized product name (rail header).
  final String brandName;

  /// Active destination's content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, size, _) {
        if (size == ScreenSize.compact) {
          return Scaffold(
            backgroundColor: context.colors.paper,
            body: child,
            bottomNavigationBar: AppBottomNav(
              items: items,
              currentIndex: currentIndex,
              onSelected: onSelected,
            ),
          );
        }
        return Scaffold(
          backgroundColor: context.colors.paper,
          body: Row(
            children: [
              AppNavRail(
                items: items,
                currentIndex: currentIndex,
                onSelected: onSelected,
                brandName: brandName,
              ),
              Expanded(child: child),
            ],
          ),
        );
      },
    );
  }
}
