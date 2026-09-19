// Feature: triggers · Layer: presentation
// "Run from app (optional)" on the connect-agent screen (Agent Triggers,
// flag-gated by the caller). Collapsed by default. A switch allows running the
// agent from the app; the trigger URL (https) is saved through
// agents-configure-trigger, and the returned secret is shown ONCE in the same
// pattern as the inbound credentials (amber warning, masked mono value, copy).
// Toggling the switch after saving enables / disables the trigger.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_text_field.dart';
import 'package:cockpit/core/widgets/copyable_field.dart';
import 'package:cockpit/features/connections/presentation/widgets/credentials_panel.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart';

/// Optional trigger setup for a newly connected agent.
class TriggerConfigSection extends ConsumerStatefulWidget {
  /// Creates the section for [agentId].
  const TriggerConfigSection({required this.agentId, super.key});

  /// The agent being configured.
  final String agentId;

  @override
  ConsumerState<TriggerConfigSection> createState() => _TriggerConfigSectionState();
}

class _TriggerConfigSectionState extends ConsumerState<TriggerConfigSection> {
  final TextEditingController _url = TextEditingController();
  bool _expanded = false;
  bool _allow = false;
  bool _showErrors = false;
  bool _busy = false;

  /// Set once saved; the secret lives only here and is never re-fetched.
  TriggerCredentials? _credentials;

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  bool get _urlValid {
    final uri = Uri.tryParse(_url.text.trim());
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
  }

  void _showMessage(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  Future<void> _save() async {
    if (!_urlValid) {
      setState(() => _showErrors = true);
      return;
    }
    FocusScope.of(context).unfocus();
    setState(() => _busy = true);
    final result = await ref.read(configureTriggerProvider)(
      agentId: widget.agentId,
      triggerUrl: _url.text,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    result.fold(
      (failure) => _showMessage(context.failureMessage(failure)),
      (credentials) {
        ref.invalidate(agentTriggersControllerProvider);
        setState(() => _credentials = credentials);
      },
    );
  }

  Future<void> _setAllow(bool allow) async {
    setState(() => _allow = allow);
    // Before saving, the switch only reveals / hides the form.
    if (_credentials == null) return;
    setState(() => _busy = true);
    final result = await ref.read(setTriggerEnabledProvider)(
      agentId: widget.agentId,
      enabled: allow,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    result.fold(
      (failure) {
        setState(() => _allow = !allow);
        _showMessage(context.failureMessage(failure));
      },
      (_) => ref.invalidate(agentTriggersControllerProvider),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final credentials = _credentials;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: _expanded,
          child: InkWell(
            key: const Key('triggerSection.toggle'),
            borderRadius: BorderRadius.circular(spacing.radiusPanel),
            onTap: () => setState(() => _expanded = !_expanded),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: spacing.minTapTarget),
              child: Row(
                children: [
                  AppIcon(AppIcons.play, size: spacing.iconSm, color: colors.accent),
                  SizedBox(width: spacing.sm),
                  Expanded(
                    child: Text(l10n.triggerSectionTitle, style: context.textTheme.titleSmall),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: AppIcon(AppIcons.chevronRight, size: spacing.iconMd, color: colors.muted),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_expanded)
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MergeSemantics(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(l10n.triggerAllowRunning, style: context.textTheme.bodyMedium),
                      ),
                      SizedBox(width: spacing.sm),
                      Switch(
                        key: const Key('triggerSection.allow'),
                        value: _allow,
                        activeTrackColor: colors.accent,
                        onChanged: _busy ? null : _setAllow,
                      ),
                    ],
                  ),
                ),
                if (_allow && credentials == null) ...[
                  SizedBox(height: spacing.md),
                  AppTextField(
                    label: l10n.triggerUrlLabel,
                    hint: l10n.triggerUrlHint,
                    controller: _url,
                    leadingIcon: AppIcons.link,
                    monospace: true,
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    errorText: _showErrors && !_urlValid ? l10n.invalidCallbackUrl : null,
                    onChanged: (_) {
                      if (_showErrors) setState(() {});
                    },
                    onSubmitted: (_) => _save(),
                  ),
                  SizedBox(height: spacing.md),
                  AppButton(
                    label: l10n.triggerSave,
                    variant: AppButtonVariant.secondary,
                    isLoading: _busy,
                    expand: true,
                    onPressed: _save,
                  ),
                ],
                if (credentials != null) ...[
                  SizedBox(height: spacing.md),
                  _TriggerSecret(credentials: credentials),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

/// The one-time trigger secret (same pattern as CredentialsPanel).
class _TriggerSecret extends StatelessWidget {
  const _TriggerSecret({required this.credentials});

  final TriggerCredentials credentials;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;

    void copied() => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(l10n.copied)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            AppIcon(AppIcons.alert, size: spacing.iconSm, color: colors.pending),
            SizedBox(width: spacing.sm - spacing.xxs / 2),
            Expanded(
              child: Text(
                l10n.triggerShownOnce,
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
          label: l10n.triggerSecretLabel,
          value: credentials.secret,
          displayValue: CredentialsPanel.maskSecret(credentials.secret),
          onCopied: copied,
        ),
      ],
    );
  }
}
