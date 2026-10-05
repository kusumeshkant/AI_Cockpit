// Locale-aware display helpers: platform names, failure messages, times.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';

/// Display formatting shortcuts.
extension FormattersContextX on BuildContext {
  String get _localeTag => Localizations.localeOf(this).toLanguageTag();

  /// Localized platform name.
  String platformLabel(AgentPlatform platform) => switch (platform) {
        AgentPlatform.n8n => l10n.platformN8n,
        AgentPlatform.make => l10n.platformMake,
        AgentPlatform.zapier => l10n.platformZapier,
        AgentPlatform.custom => l10n.platformCustom,
      };

  /// "platform · name" source line; either part may be missing.
  String sourceLabel(AgentPlatform? platform, String? name) {
    final platformText = platform == null ? null : platformLabel(platform);
    if (platformText != null && name != null) {
      return l10n.metaPair(platformText, name);
    }
    return platformText ?? name ?? '';
  }

  /// Localized message for an error surfaced by a controller.
  String failureMessage(Object? error) => switch (error) {
        NetworkFailure() => l10n.errorNetwork,
        ServerFailure() => l10n.errorServer,
        AuthFailure() => l10n.errorAuth,
        ConflictFailure() => l10n.alreadyDecided,
        ExpiredFailure() => l10n.errorExpired,
        ValidationFailure() => l10n.errorValidation,
        RateLimitedFailure() => l10n.errorRateLimited,
        FeatureDisabledFailure() => l10n.errorFeatureDisabled,
        TriggerDisabledFailure() => l10n.errorTriggerDisabled,
        _ => l10n.errorGeneric,
      };

  /// Clock time, e.g. "7:04 AM".
  String formatClock(DateTime time) =>
      DateFormat.jm(_localeTag).format(time.toLocal());

  /// Audit-style day label: clock time today, "Yesterday", weekday within a
  /// week, otherwise a short date.
  String formatDayOrTime(DateTime time, {DateTime? now}) {
    final local = time.toLocal();
    final today = DateUtils.dateOnly(now ?? DateTime.now());
    final days = today.difference(DateUtils.dateOnly(local)).inDays;
    if (days <= 0) return formatClock(local);
    if (days == 1) return l10n.yesterday;
    if (days < 7) return DateFormat.E(_localeTag).format(local);
    return DateFormat.MMMd(_localeTag).format(local);
  }

  /// Relative age, e.g. "4 min ago".
  String formatAgo(DateTime time, {DateTime? now}) {
    final elapsed = (now ?? DateTime.now()).difference(time);
    if (elapsed.inMinutes < 1) return l10n.justNow;
    if (elapsed.inHours < 1) return l10n.minutesAgo(elapsed.inMinutes);
    if (elapsed.inDays < 1) return l10n.hoursAgo(elapsed.inHours);
    return l10n.daysAgo(elapsed.inDays);
  }
}
