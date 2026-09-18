// Feature: connections · Layer: presentation
// One-time credentials (design: ConnectAgent.dc.html): amber "shown once"
// warning, inbound URL and masked signing secret with copy buttons (TR-8).
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/copyable_field.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';

/// Credentials panel.
class CredentialsPanel extends StatelessWidget {
  /// Creates the panel.
  const CredentialsPanel({required this.credentials, super.key});

  /// Number of trailing secret characters left visible.
  static const int visibleSecretChars = 4;

  /// Mask characters between the secret prefix and its visible tail.
  static const int maskLength = 12;

  /// The freshly created credentials.
  final AgentCredentials credentials;

  /// Masks a secret as `prefix_••••••••••••tail`.
  static String maskSecret(String secret) {
    if (secret.length <= visibleSecretChars) return secret;
    final separator = secret.indexOf('_');
    final prefix = separator < 0 ? '' : secret.substring(0, separator + 1);
    final tail = secret.substring(secret.length - visibleSecretChars);
    return '$prefix${'•' * maskLength}$tail';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;

    void copied() => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.copied)));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIcon(AppIcons.alert, size: spacing.iconSm, color: colors.pending),
              SizedBox(width: spacing.sm - spacing.xxs / 2),
              Expanded(
                child: Text(
                  l10n.shownOnceWarning,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: colors.pending,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          CopyableField(
            label: l10n.inboundUrl,
            value: credentials.inboundUrl,
            displayValue: credentials.inboundUrl.replaceFirst('https://', ''),
            onCopied: copied,
          ),
          SizedBox(height: spacing.md),
          CopyableField(
            label: l10n.signingSecret,
            value: credentials.inboundSecret,
            displayValue: maskSecret(credentials.inboundSecret),
            onCopied: copied,
          ),
        ],
      ),
    );
  }
}
