// Applies the script-aware label styles app-wide: rebuilds the ambient Theme
// with AppTheme.localize for the resolved locale, so every widget reading
// `context.textTheme.labelMedium` / `labelSmall` (section labels, pills, nav,
// timestamps) or the tooltip theme gets the right font and tracking. Mounted
// in MaterialApp.builder (below Localizations and the app Theme).
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Theme;

import 'package:cockpit/core/theme/app_theme.dart';

/// Adapts the ambient theme's label styles to the active locale.
class LocalizedTypography extends StatelessWidget {
  /// Creates the wrapper.
  const LocalizedTypography({required this.child, super.key});

  /// The app content.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Always wrap (even when nothing changes) so a language switch never
    // changes the tree shape and remounts the app below.
    return Theme(
      data: AppTheme.localize(
        Theme.of(context),
        Localizations.maybeLocaleOf(context),
      ),
      child: child,
    );
  }
}
