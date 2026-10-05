// Feature: triggers · Layer: presentation
// Run control for the Connections row (Agent Triggers, flag-gated by the
// caller). States: idle → running (spinner, disabled) → success (brief
// STARTED pill, fades) / error (retry, stop-tinted). TriggerStatusLine shows
// "last run · Xm ago" (mono muted), or the error note.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_top_bar.dart';
import 'package:cockpit/core/widgets/status_pill.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart';

/// Trailing Run button for one agent.
class RunAgentButton extends ConsumerWidget {
  /// Creates the button for [agentId].
  const RunAgentButton({required this.agentId, super.key});

  /// Duration of the cross-fade between states.
  static const Duration fade = Duration(milliseconds: 250);

  /// The agent to run.
  final String agentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final spacing = context.spacing;
    final state = ref.watch(runAgentControllerProvider(agentId));
    void run() => ref.read(runAgentControllerProvider(agentId).notifier).run();

    final Widget child = switch (state) {
      RunAgentIdle() => AppIconButton(
          key: const ValueKey('idle'),
          icon: AppIcons.play,
          tooltip: l10n.triggerRunLabel,
          color: colors.accent,
          filled: false,
          onPressed: run,
        ),
      RunAgentRunning() => Semantics(
          key: const ValueKey('running'),
          label: l10n.triggerRunLabel,
          enabled: false,
          child: SizedBox.square(
            dimension: spacing.minTapTarget,
            child: Center(
              child: SizedBox.square(
                dimension: spacing.iconSm,
                child: CircularProgressIndicator(
                  strokeWidth: spacing.xxs,
                  color: colors.accent,
                ),
              ),
            ),
          ),
        ),
      RunAgentSuccess() => SizedBox(
          key: const ValueKey('success'),
          height: spacing.minTapTarget,
          child: Center(
            child: StatusPill(label: l10n.triggerStarted, tone: StatusTone.go),
          ),
        ),
      RunAgentError() => AppIconButton(
          key: const ValueKey('error'),
          icon: AppIcons.play,
          tooltip: l10n.retry,
          color: colors.stop,
          filled: false,
          onPressed: run,
        ),
    };

    return AnimatedSwitcher(duration: fade, child: child);
  }
}

/// "last run · Xm ago", or the latest run error, under the agent's meta line.
class TriggerStatusLine extends ConsumerWidget {
  /// Creates the line for [trigger].
  const TriggerStatusLine({required this.trigger, super.key});

  /// The agent's trigger.
  final AgentTrigger trigger;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final state = ref.watch(runAgentControllerProvider(trigger.agentId));
    final style = context.textTheme.labelMedium?.copyWith(letterSpacing: 0);

    final String? text;
    final Color color;
    if (state case RunAgentError(:final failure)) {
      color = colors.stop;
      text = switch (failure) {
        RateLimitedFailure(:final retryAfter) when retryAfter != null =>
          l10n.triggerRateLimited(retryAfter.inSeconds.clamp(1, 1 << 16)),
        TriggerDisabledFailure() || FeatureDisabledFailure() => context.failureMessage(failure),
        _ => l10n.triggerRunFailed,
      };
    } else {
      color = colors.muted;
      final lastRunAt = trigger.lastRunAt;
      text = lastRunAt == null ? null : l10n.triggerLastRun(context.formatAgo(lastRunAt));
    }

    if (text == null) return const SizedBox.shrink();
    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: style?.copyWith(color: color),
    );
  }
}
