// Error state with a localized message and optional retry.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_icon.dart';

/// Full-area error state.
class AppErrorView extends StatelessWidget {
  /// Creates an error view.
  const AppErrorView({required this.message, this.onRetry, super.key});

  /// Localized message.
  final String message;

  /// Retry handler; hides the button when `null`.
  final VoidCallback? onRetry;

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
            AppIcon(AppIcons.alert, size: spacing.iconXl, color: colors.stop),
            SizedBox(height: spacing.md),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(color: colors.inkSoft),
            ),
            if (onRetry != null) ...[
              SizedBox(height: spacing.lg),
              AppButton(
                label: context.l10n.retry,
                variant: AppButtonVariant.secondary,
                onPressed: onRetry,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
