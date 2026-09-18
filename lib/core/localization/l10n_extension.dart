// `context.l10n` shortcut to generated localizations.
import 'package:flutter/widgets.dart';

import 'package:cockpit/l10n/app_localizations.dart';

/// Localization shortcut.
extension L10nContextX on BuildContext {
  /// Localized strings for the active locale.
  AppLocalizations get l10n => AppLocalizations.of(this);
}
