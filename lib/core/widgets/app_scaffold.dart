// Standard screen shell: optional top bar, body on paper, optional bottom bar
// (decision bar / CTA). Primary navigation lives in the app shell, not here.
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';

/// Cockpit's screen scaffold.
class AppScaffold extends StatelessWidget {
  /// Creates a scaffold.
  const AppScaffold({
    required this.body,
    this.topBar,
    this.bottomBar,
    super.key,
  });

  /// Header (usually an AppTopBar).
  final Widget? topBar;

  /// Screen content.
  final Widget body;

  /// Sticky bar pinned above the keyboard/safe area.
  final Widget? bottomBar;

  @override
  Widget build(BuildContext context) {
    // The bar is part of the body column, not Scaffold.bottomNavigationBar:
    // the body is resized above the keyboard, the navigation-bar slot is not,
    // so a CTA there would hide behind the keyboard (F16).
    return Scaffold(
      backgroundColor: context.colors.paper,
      body: Column(
        children: [
          ?topBar,
          Expanded(child: body),
          ?bottomBar,
        ],
      ),
    );
  }
}

/// Sticky bottom bar container: surface fill, top hairline, safe-area aware.
class AppBottomBar extends StatelessWidget {
  /// Creates the bar.
  const AppBottomBar({required this.child, super.key});

  /// Bar content (buttons).
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.line)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            spacing.screenPadding,
            spacing.md,
            spacing.screenPadding,
            spacing.lg,
          ),
          child: child,
        ),
      ),
    );
  }
}
