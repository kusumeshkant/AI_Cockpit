// Startup: the brand mark and a spinner while the first auth event is
// pending (F21), so a signed-out user never sees the feed shell flash.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_loader.dart';
import 'package:cockpit/core/widgets/brand_mark.dart';

/// Branded startup spinner.
class StartupScreen extends StatelessWidget {
  /// Creates the screen.
  const StartupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Scaffold(
      backgroundColor: context.colors.paper,
      body: Center(
        child: Semantics(
          label: context.l10n.loading,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BrandMark(size: spacing.brandMarkLarge, halo: true),
              SizedBox(height: spacing.xl),
              const AppLoader(),
            ],
          ),
        ),
      ),
    );
  }
}
