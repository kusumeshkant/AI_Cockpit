// Terms of Service / Privacy Policy links (F03). URLs come from AppConfig
// (TERMS_URL / PRIVACY_URL); a link without a URL is not shown, and nothing
// renders when neither is set. Links open in the external browser.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/config/config_providers.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';

/// A legal page the app links to.
enum LegalPage {
  /// Terms of Service.
  terms,

  /// Privacy Policy.
  privacy,
}

/// Opens [page] if it is configured; shows a snackbar when it can't be opened.
Future<void> openLegalPage(BuildContext context, WidgetRef ref, LegalPage page) async {
  final config = ref.read(appConfigProvider);
  final uri = switch (page) {
    LegalPage.terms => config.termsUri,
    LegalPage.privacy => config.privacyUri,
  };
  if (uri == null) return;
  final opened = await ref.read(externalUrlOpenerProvider)(uri);
  if (!opened && context.mounted) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(context.l10n.linkOpenFailed)));
  }
}

/// The configured legal pages, in display order.
List<LegalPage> configuredLegalPages(WidgetRef ref) {
  final config = ref.watch(appConfigProvider);
  return [
    if (config.termsUri != null) LegalPage.terms,
    if (config.privacyUri != null) LegalPage.privacy,
  ];
}

/// Localized label for [page].
String legalPageLabel(BuildContext context, LegalPage page) => switch (page) {
      LegalPage.terms => context.l10n.termsOfService,
      LegalPage.privacy => context.l10n.privacyPolicy,
    };

/// Inline row of legal links (sign-in footer). Wraps on narrow screens.
class LegalLinks extends ConsumerWidget {
  /// Creates the links.
  const LegalLinks({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pages = configuredLegalPages(ref);
    if (pages.isEmpty) return const SizedBox.shrink();
    final style = context.textTheme.bodySmall?.copyWith(
      color: context.colors.accent,
      decoration: TextDecoration.underline,
    );
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: context.spacing.xs,
      children: [
        for (final page in pages)
          TextButton(
            onPressed: () => openLegalPage(context, ref, page),
            child: Text(legalPageLabel(context, page), style: style),
          ),
      ],
    );
  }
}
