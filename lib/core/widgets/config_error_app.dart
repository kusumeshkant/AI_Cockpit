// Shown instead of the app when a prod build is missing its backend
// configuration (see AppConfig.blocksStartup), so a mis-built release never
// runs on demo data. Standalone: no DI, router or Riverpod.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/theme/localized_typography.dart';
import 'package:cockpit/core/widgets/app_empty_view.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/l10n/app_localizations.dart';

/// Root widget for a build that cannot start.
class ConfigErrorApp extends StatelessWidget {
  /// Creates the config-error app.
  const ConfigErrorApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        onGenerateTitle: (context) => context.l10n.appTitle,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.buildLight(),
        darkTheme: AppTheme.buildDark(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => LocalizedTypography(child: child ?? const SizedBox.shrink()),
        home: const ConfigErrorScreen(),
      );
}

/// Explains that this build is missing its server settings.
class ConfigErrorScreen extends StatelessWidget {
  /// Creates the screen.
  const ConfigErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      backgroundColor: context.colors.paper,
      body: SafeArea(
        child: AppEmptyView(
          icon: AppIcons.alert,
          title: l10n.configErrorTitle,
          message: l10n.configErrorBody,
        ),
      ),
    );
  }
}
