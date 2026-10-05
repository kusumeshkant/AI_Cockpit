// Feature: triggers · Layer: presentation
// Bottom sheet to manage an existing agent's trigger (Agent Triggers,
// owner-only; opened from the Connections row). Shows whether a trigger is set
// up and enabled plus the secret hint — never the secret. The owner can switch
// it on / off (the Run button follows immediately), save a new https URL, or
// rotate the secret. Configuring always issues a new secret (the backend
// rotates on every configure), so re-saving / rotating asks for confirmation
// first; the new secret is shown ONCE in this sheet instance only.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_text_field.dart';
import 'package:cockpit/core/widgets/status_pill.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart';
import 'package:cockpit/features/triggers/presentation/widgets/trigger_config_section.dart';

/// Opens the manage-trigger sheet for [agent].
Future<void> showManageTriggerSheet(BuildContext context, {required Agent agent}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: context.colors.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(context.spacing.radiusCard),
      ),
    ),
    builder: (_) => ManageTriggerSheet(agent: agent),
  );
}

/// Trigger management for one existing agent.
class ManageTriggerSheet extends ConsumerStatefulWidget {
  /// Creates the sheet for [agent].
  const ManageTriggerSheet({required this.agent, super.key});

  /// The agent whose trigger is managed.
  final Agent agent;

  @override
  ConsumerState<ManageTriggerSheet> createState() => _ManageTriggerSheetState();
}

class _ManageTriggerSheetState extends ConsumerState<ManageTriggerSheet> {
  late final TextEditingController _url;
  bool _showErrors = false;
  bool _busy = false;
  String? _error;

  /// Set when a secret is issued here; lives only in this sheet instance.
  TriggerCredentials? _credentials;

  AgentTrigger? get _trigger =>
      ref.read(agentTriggersControllerProvider).value?[widget.agent.id];

  @override
  void initState() {
    super.initState();
    _url = TextEditingController(text: _trigger?.triggerUrl ?? '');
  }

  @override
  void dispose() {
    _url.dispose();
    super.dispose();
  }

  bool get _urlValid {
    final uri = Uri.tryParse(_url.text.trim());
    return uri != null && uri.scheme == 'https' && uri.host.isNotEmpty;
  }

  /// Every configure call issues a new secret; confirm when one exists.
  Future<bool> _confirmNewSecret() async {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: context.colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(spacing.radiusCard),
        ),
        title: Text(l10n.triggerRotateTitle, style: context.textTheme.titleMedium),
        content: Text(l10n.triggerRotateBody, style: context.textTheme.bodyMedium),
        actionsOverflowButtonSpacing: spacing.sm,
        actions: [
          AppButton(
            key: const Key('manageTrigger.cancel'),
            label: l10n.cancel,
            variant: AppButtonVariant.secondary,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          AppButton(
            key: const Key('manageTrigger.confirm'),
            label: l10n.triggerRotateConfirm,
            variant: AppButtonVariant.danger,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }

  Future<void> _configure(String url) async {
    final existing = _trigger;
    if (existing != null && !await _confirmNewSecret()) return;
    if (!mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref.read(configureTriggerProvider)(
      agentId: widget.agent.id,
      triggerUrl: url,
      // Keep the owner's interval; configure resets it otherwise.
      minIntervalSecs: existing?.minIntervalSecs,
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _busy = false;
        _error = context.failureMessage(failure);
      }),
      (credentials) {
        ref.read(agentTriggersControllerProvider.notifier).upsert(credentials.trigger);
        setState(() {
          _busy = false;
          _credentials = credentials;
          _url.text = credentials.trigger.triggerUrl;
        });
      },
    );
  }

  Future<void> _save() async {
    if (!_urlValid) {
      setState(() => _showErrors = true);
      return;
    }
    FocusScope.of(context).unfocus();
    await _configure(_url.text.trim());
  }

  Future<void> _rotate() async {
    final trigger = _trigger;
    if (trigger == null) return;
    await _configure(trigger.triggerUrl);
  }

  Future<void> _setEnabled(bool enabled) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref.read(setTriggerEnabledProvider)(
      agentId: widget.agent.id,
      enabled: enabled,
    );
    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _busy = false;
        _error = context.failureMessage(failure);
      }),
      (trigger) {
        // The row's Run button follows at once (no refetch needed).
        ref.read(agentTriggersControllerProvider.notifier).upsert(trigger);
        setState(() => _busy = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final trigger = ref.watch(
      agentTriggersControllerProvider.select((triggers) => triggers.value?[widget.agent.id]),
    );
    final credentials = _credentials;
    final error = _error;

    final (statusLabel, statusTone) = switch (trigger) {
      null => (l10n.triggerStatusNotSetUp, StatusTone.pending),
      AgentTrigger(enabled: true) => (l10n.triggerStatusOn, StatusTone.go),
      _ => (l10n.triggerStatusOff, StatusTone.stop),
    };

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: spacing.lg,
        right: spacing.lg,
        top: spacing.xl,
        bottom: MediaQuery.viewInsetsOf(context).bottom + spacing.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              AppIcon(AppIcons.play, size: spacing.iconSm, color: colors.accent),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Text(l10n.triggerManageTitle, style: context.textTheme.titleLarge),
              ),
              SizedBox(width: spacing.sm),
              StatusPill(
                key: const Key('manageTrigger.status'),
                label: statusLabel,
                tone: statusTone,
              ),
            ],
          ),
          SizedBox(height: spacing.xxs),
          Text(
            widget.agent.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelMedium?.copyWith(color: colors.muted, letterSpacing: 0),
          ),
          if (trigger != null) ...[
            SizedBox(height: spacing.md),
            MergeSemantics(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: spacing.minTapTarget),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(l10n.triggerAllowRunning, style: context.textTheme.bodyMedium),
                    ),
                    SizedBox(width: spacing.sm),
                    Switch(
                      key: const Key('manageTrigger.enabled'),
                      value: trigger.enabled,
                      activeTrackColor: colors.accent,
                      onChanged: _busy ? null : _setEnabled,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              l10n.triggerSecretHint(trigger.secretHint),
              key: const Key('manageTrigger.hint'),
              style: context.textTheme.labelMedium?.copyWith(color: colors.muted, letterSpacing: 0),
            ),
          ],
          SizedBox(height: spacing.md),
          AppTextField(
            key: const Key('manageTrigger.url'),
            label: l10n.triggerUrlLabel,
            hint: l10n.triggerUrlHint,
            controller: _url,
            leadingIcon: AppIcons.link,
            monospace: true,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
            enabled: !_busy,
            errorText: _showErrors && !_urlValid ? l10n.invalidCallbackUrl : null,
            onChanged: (_) {
              if (_showErrors) setState(() {});
            },
            onSubmitted: (_) => _save(),
          ),
          SizedBox(height: spacing.md),
          AppButton(
            key: const Key('manageTrigger.save'),
            label: l10n.triggerSave,
            variant: AppButtonVariant.secondary,
            isLoading: _busy,
            expand: true,
            onPressed: _busy ? null : _save,
          ),
          if (trigger != null) ...[
            SizedBox(height: spacing.sm),
            AppButton(
              key: const Key('manageTrigger.rotate'),
              label: l10n.triggerRotate,
              variant: AppButtonVariant.danger,
              expand: true,
              onPressed: _busy ? null : _rotate,
            ),
          ],
          if (error != null) ...[
            SizedBox(height: spacing.sm),
            Text(
              error,
              key: const Key('manageTrigger.error'),
              style: context.textTheme.bodySmall?.copyWith(color: colors.stop),
            ),
          ],
          if (credentials != null) ...[
            SizedBox(height: spacing.lg),
            TriggerSecretPanel(credentials: credentials),
          ],
        ],
      ),
    );
  }
}
