// Empty state with icon, title, message and optional action.
import 'package:flutter/material.dart';

import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_icon.dart';

/// Full-area empty state.
class AppEmptyView extends StatelessWidget {
  /// Creates an empty view.
  const AppEmptyView({
    required this.title,
    this.message,
    this.icon = AppIcons.tray,
    this.action,
    super.key,
  });

  /// Localized title.
  final String title;

  /// Localized supporting message.
  final String? message;

  /// Illustration glyph.
  final AppIcons icon;

  /// Optional call to action.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppIcon(icon, size: spacing.iconXl, color: colors.muted),
            SizedBox(height: spacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.titleMedium,
            ),
            if (message != null) ...[
              SizedBox(height: spacing.xs),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(color: colors.muted),
              ),
            ],
            if (action != null) ...[
              SizedBox(height: spacing.lg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
