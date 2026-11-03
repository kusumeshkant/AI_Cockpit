// Feature: agent_services · Layer: presentation
// Consent before enabling a service (text version v1 =
// currentServiceConsentVersion): what is shared, how long it is kept, and
// that the owner stays in control. Enable stays disabled until the box is
// ticked. Resolves `true` only on an explicit Enable.
import 'package:flutter/material.dart';

import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';

/// Shows the consent sheet for [serviceName].
Future<bool> showServiceConsent(BuildContext context, String serviceName) async {
  final accepted = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.colors.surface,
    builder: (_) => ServiceConsentSheet(serviceName: serviceName),
  );
  return accepted ?? false;
}

/// The consent content.
class ServiceConsentSheet extends StatefulWidget {
  /// Creates the sheet.
  const ServiceConsentSheet({required this.serviceName, super.key});

  /// The service being enabled.
  final String serviceName;

  @override
  State<ServiceConsentSheet> createState() => _ServiceConsentSheetState();
}

class _ServiceConsentSheetState extends State<ServiceConsentSheet> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final colors = context.colors;
    Widget point(String text) => Padding(
          padding: EdgeInsets.only(bottom: spacing.sm),
          child: Text(text, style: context.textTheme.bodyMedium),
        );

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(spacing.screenPadding, spacing.lg, spacing.screenPadding, spacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            header: true,
            child: Text(l10n.serviceConsentTitle(widget.serviceName), style: context.textTheme.titleMedium),
          ),
          SizedBox(height: spacing.md),
          point(l10n.serviceConsentShared),
          point(l10n.serviceConsentRetention),
          point(l10n.serviceConsentControl),
          SizedBox(height: spacing.sm),
          MergeSemantics(
            child: InkWell(
              key: const Key('consent.agree'),
              onTap: () => setState(() => _agreed = !_agreed),
              borderRadius: BorderRadius.circular(spacing.radiusButton),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: spacing.buttonHeight),
                child: Row(
                  children: [
                    Checkbox(
                      value: _agreed,
                      activeColor: colors.accent,
                      onChanged: (value) => setState(() => _agreed = value ?? false),
                    ),
                    SizedBox(width: spacing.xs),
                    Expanded(child: Text(l10n.serviceConsentCheckbox, style: context.textTheme.bodyMedium)),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: spacing.md),
          AppButton(
            key: const Key('consent.enable'),
            label: l10n.serviceEnable,
            expand: true,
            onPressed: _agreed ? () => Navigator.of(context).pop(true) : null,
          ),
          SizedBox(height: spacing.sm),
          AppButton(
            key: const Key('consent.cancel'),
            label: l10n.cancel,
            variant: AppButtonVariant.secondary,
            expand: true,
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ],
      ),
    );
  }
}

/// Asks before disabling [serviceName]; the safe choice (Cancel) has focus.
/// Resolves `true` only on an explicit Disable.
Future<bool> confirmServiceDisable(BuildContext context, String serviceName) async {
  final l10n = context.l10n;
  final spacing = context.spacing;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(spacing.radiusCard)),
      title: Text(l10n.serviceDisableTitle(serviceName), style: context.textTheme.titleMedium),
      content: Text(l10n.serviceDisableBody, style: context.textTheme.bodyMedium),
      actionsOverflowButtonSpacing: spacing.sm,
      actions: [
        AppButton(
          key: const Key('serviceDisable.cancel'),
          label: l10n.cancel,
          variant: AppButtonVariant.secondary,
          autofocus: true,
          onPressed: () => Navigator.of(dialogContext).pop(false),
        ),
        AppButton(
          key: const Key('serviceDisable.confirm'),
          label: l10n.serviceDisable,
          variant: AppButtonVariant.danger,
          onPressed: () => Navigator.of(dialogContext).pop(true),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
