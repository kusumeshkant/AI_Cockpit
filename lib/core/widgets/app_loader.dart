// Centered loading indicator with an accessible label.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';

/// Full-area loading state.
class AppLoader extends StatelessWidget {
  /// Creates a loader.
  const AppLoader({super.key});

  @override
  Widget build(BuildContext context) => Center(
        child: CircularProgressIndicator(
          semanticsLabel: context.l10n.loading,
          color: context.colors.accent,
          strokeWidth: context.spacing.xxs,
        ),
      );
}
