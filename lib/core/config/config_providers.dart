// Riverpod access to the build configuration and to opening external links,
// so widgets don't read compile-time defines or platform plugins directly
// (and tests can override both).
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cockpit/core/config/app_config.dart';

/// The current build's [AppConfig].
final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.fromEnvironment());

/// Opens a URL outside the app; resolves `false` when it could not be opened.
typedef ExternalUrlOpener = Future<bool> Function(Uri url);

/// Opens links in the external browser (ADR-011).
final externalUrlOpenerProvider = Provider<ExternalUrlOpener>((ref) => _openExternally);

Future<bool> _openExternally(Uri url) async {
  try {
    return await launchUrl(url, mode: LaunchMode.externalApplication);
  } on Object {
    // No browser / plugin error: report "not opened" instead of throwing.
    return false;
  }
}
