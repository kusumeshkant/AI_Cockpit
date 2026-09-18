// Root widget: MaterialApp.router wired to theme mode, locale, localization
// delegates and the GoRouter provider. PushGate ties push notifications to
// the signed-in session.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/localization/locale_controller.dart';
import 'package:cockpit/core/router/app_router.dart';
import 'package:cockpit/core/theme/localized_typography.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/theme/theme_controller.dart';
import 'package:cockpit/features/notifications/presentation/push_gate.dart';
import 'package:cockpit/l10n/app_localizations.dart';

/// The Cockpit application.
class CockpitApp extends ConsumerWidget {
  /// Creates the root app widget.
  const CockpitApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeControllerProvider);

    return MaterialApp.router(
      onGenerateTitle: (context) => context.l10n.appTitle,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.buildLight(),
      darkTheme: AppTheme.buildDark(),
      themeMode: themeMode,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
      builder: (context, child) => LocalizedTypography(
        child: PushGate(child: child ?? const SizedBox.shrink()),
      ),
    );
  }
}
