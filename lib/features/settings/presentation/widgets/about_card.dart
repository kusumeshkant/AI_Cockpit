// Feature: settings · Layer: presentation
// Settings → About (F12): the app version (APP_VERSION) and, when
// SUPPORT_EMAIL is configured, a row that opens a mail to support.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/config/app_config.dart';
import 'package:cockpit/core/config/config_providers.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/features/auth/domain/value_objects/email_address.dart';

/// Version and support contact.
class AboutCard extends ConsumerWidget {
  /// Creates the card.
  const AboutCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final support = ref.watch(appConfigProvider).supportEmail.trim();
    final hasSupport = EmailAddress.isValid(support);

    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(minHeight: spacing.minTapTarget),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.cardPadding,
                vertical: spacing.sm,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(
                  l10n.versionLabel(AppConfig.appVersion),
                  key: const ValueKey('settings_about_version'),
                  style: context.textTheme.titleSmall,
                ),
              ),
            ),
          ),
          if (hasSupport) ...[
            const Divider(),
            _SupportRow(email: support),
          ],
        ],
      ),
    );
  }
}

class _SupportRow extends ConsumerWidget {
  const _SupportRow({required this.email});

  final String email;

  Future<void> _open(BuildContext context, WidgetRef ref) async {
    final opened = await ref.read(externalUrlOpenerProvider)(Uri(scheme: 'mailto', path: email));
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(context.l10n.linkOpenFailed)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = context.spacing;
    final colors = context.colors;
    final label = context.l10n.contactSupport;
    return Semantics(
      link: true,
      label: '$label, $email',
      excludeSemantics: true,
      child: InkWell(
        key: const ValueKey('settings_about_support'),
        onTap: () => _open(context, ref),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: spacing.minTapTarget),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: spacing.cardPadding, vertical: spacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(label, style: context.textTheme.titleSmall),
                      Text(
                        email,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.textTheme.labelMedium?.copyWith(color: colors.muted),
                      ),
                    ],
                  ),
                ),
                AppIcon(AppIcons.mail, color: colors.muted),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
