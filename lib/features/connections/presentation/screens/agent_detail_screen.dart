// Feature: connections · Layer: presentation
// Agent detail (opened from a Connections row): status, last action time,
// latest callback delivery and "Send a test action". The test action does not
// depend on Agent Triggers: it is offered whenever the backend can create one
// (live mode) and the user may manage agents (owner; the backend enforces it).
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_card.dart';
import 'package:cockpit/core/widgets/app_empty_view.dart';
import 'package:cockpit/core/widgets/app_error_view.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_loader.dart';
import 'package:cockpit/core/widgets/app_scaffold.dart';
import 'package:cockpit/core/widgets/app_top_bar.dart';
import 'package:cockpit/core/widgets/status_pill.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/domain/entities/callback_delivery.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';

/// Agent detail screen.
class AgentDetailScreen extends ConsumerStatefulWidget {
  /// Creates the screen for [agentId].
  const AgentDetailScreen({required this.agentId, super.key});

  /// The agent shown.
  final String agentId;

  @override
  ConsumerState<AgentDetailScreen> createState() => _AgentDetailScreenState();
}

class _AgentDetailScreenState extends ConsumerState<AgentDetailScreen> {
  bool _sending = false;

  void _close() {
    final router = GoRouter.maybeOf(context);
    if (router != null && router.canPop()) {
      router.pop();
    } else {
      Navigator.of(context).maybePop();
    }
  }

  void _showMessage(String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  Future<void> _sendTest() async {
    setState(() => _sending = true);
    final failure = await ref
        .read(connectionsControllerProvider.notifier)
        .sendTestAction(widget.agentId);
    if (!mounted) return;
    setState(() => _sending = false);
    _showMessage(
      failure == null ? context.l10n.testActionSent : context.failureMessage(failure),
    );
  }

  Future<void> _refresh() async {
    ref
      ..invalidate(lastCallbackProvider(widget.agentId))
      ..invalidate(connectionsControllerProvider);
    await ref.read(connectionsControllerProvider.future);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final agents = ref.watch(connectionsControllerProvider);
    final listed = agents.value?.where((a) => a.id == widget.agentId).firstOrNull;
    final agent = listed == null ? null : ref.watch(liveAgentProvider(listed));
    // Same gates as Connect agent: live backend only, owner (or unknown role).
    final testActions =
        ref.watch(testActionsSupportedProvider) && ref.watch(canManageAgentsProvider);
    final live = agent?.status == AgentStatus.active;

    return AppScaffold(
      topBar: AppTopBar.back(title: agent?.name ?? '', onBack: _close),
      bottomBar: agent == null || !testActions
          ? null
          : AppBottomBar(
              child: AppButton(
                key: const Key('agentDetail.sendTest'),
                label: l10n.sendTestAction,
                isLoading: _sending,
                expand: true,
                onPressed: live ? _sendTest : null,
              ),
            ),
      body: switch (agents) {
        _ when agent != null => RefreshIndicator(
            color: context.colors.accent,
            backgroundColor: context.colors.surface,
            onRefresh: _refresh,
            child: _AgentDetailBody(agent: agent, showTestHint: testActions),
          ),
        AsyncData() => AppEmptyView(
            icon: AppIcons.link,
            title: l10n.agentNotFound,
            message: l10n.errorNotFound,
          ),
        AsyncError(:final error) => AppErrorView(
            message: context.failureMessage(error),
            onRetry: () => ref.invalidate(connectionsControllerProvider),
          ),
        _ => const AppLoader(),
      },
    );
  }
}

class _AgentDetailBody extends StatelessWidget {
  const _AgentDetailBody({required this.agent, required this.showTestHint});

  final Agent agent;
  final bool showTestHint;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final live = agent.status == AgentStatus.active;
    final lastActionAt = agent.lastActionAt;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.all(spacing.screenPadding),
      children: [
        AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DetailRow(
                key: const Key('agentDetail.status'),
                label: l10n.agentDetailStatus,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: StatusPill.bare(
                    label: live ? l10n.statusLive : l10n.statusPaused,
                    tone: live ? StatusTone.go : StatusTone.pending,
                  ),
                ),
              ),
              const Divider(),
              _DetailRow(
                key: const Key('agentDetail.lastAction'),
                label: l10n.agentDetailLastAction,
                child: _Value(
                  lastActionAt == null
                      ? l10n.agentDetailNoActions
                      : context.formatAgo(lastActionAt),
                ),
              ),
              const Divider(),
              _DetailRow(
                key: const Key('agentDetail.callback'),
                label: l10n.agentDetailCallback,
                child: _CallbackValue(agentId: agent.id),
              ),
              const Divider(),
              _DetailRow(
                label: l10n.callbackUrl,
                child: _Value(agent.callbackUrl),
              ),
            ],
          ),
        ),
        if (showTestHint) ...[
          SizedBox(height: spacing.lg),
          Text(
            live ? l10n.testActionHint : l10n.testActionPausedHint,
            style: context.textTheme.bodySmall?.copyWith(color: colors.muted),
          ),
        ],
      ],
    );
  }
}

/// The latest callback delivery: loading, none yet, state + time, or a
/// non-blocking "couldn't load" line.
class _CallbackValue extends ConsumerWidget {
  const _CallbackValue({required this.agentId});

  final String agentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final delivery = ref.watch(lastCallbackProvider(agentId));
    return switch (delivery) {
      AsyncData(value: null) => _Value(l10n.callbackNone),
      AsyncData(:final value?) => _ToneLine(
          text: switch (value.state) {
            CallbackDeliveryState.delivered => l10n.callbackDeliveredAgo(context.formatAgo(value.at)),
            CallbackDeliveryState.retrying => l10n.callbackRetryingAgo(context.formatAgo(value.at)),
            CallbackDeliveryState.failed => l10n.callbackFailedAgo(context.formatAgo(value.at)),
          },
          color: switch (value.state) {
            CallbackDeliveryState.delivered => colors.go,
            CallbackDeliveryState.retrying => colors.pending,
            CallbackDeliveryState.failed => colors.stop,
          },
        ),
      AsyncError() => _Value(l10n.callbackUnavailable, color: colors.muted),
      _ => Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox.square(
            dimension: context.spacing.iconSm,
            child: CircularProgressIndicator(
              strokeWidth: context.spacing.borderThick,
              color: colors.muted,
            ),
          ),
        ),
    };
  }
}

/// Status dot + text that wraps (the bare pill does not, and the Hindi
/// retry line is long at 320px).
class _ToneLine extends StatelessWidget {
  const _ToneLine({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final style = context.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          // Centre the dot on the first line.
          padding: EdgeInsets.only(
            top: ((style?.fontSize ?? spacing.md) * (style?.height ?? 1.4) - spacing.dotMd) / 2,
          ),
          child: SizedBox.square(
            dimension: spacing.dotMd,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        ),
        SizedBox(width: spacing.xs + spacing.xxs / 2),
        Expanded(child: Text(text, style: style)),
      ],
    );
  }
}

/// Label above its value, stacked so long values (URLs, Hindi) fit at 320px.
class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.child, super.key});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.cardPadding,
        vertical: spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: context.textTheme.labelMedium?.copyWith(
              color: context.colors.muted,
              letterSpacing: 0,
            ),
          ),
          SizedBox(height: spacing.xs),
          child,
        ],
      ),
    );
  }
}

class _Value extends StatelessWidget {
  const _Value(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: context.textTheme.bodyMedium?.copyWith(color: color ?? context.colors.ink),
      );
}
