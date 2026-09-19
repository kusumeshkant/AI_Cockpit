// Feature: connections · Layer: presentation
// Connections (design: technical/design/Connections.dc.html): title with a
// compact "Connect" button, then the agent list.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cockpit/core/config/feature_flags.dart';
import 'package:cockpit/core/localization/formatters.dart';
import 'package:cockpit/core/localization/l10n_extension.dart';
import 'package:cockpit/core/router/routes.dart';
import 'package:cockpit/core/theme/app_theme.dart';
import 'package:cockpit/core/widgets/app_button.dart';
import 'package:cockpit/core/widgets/app_empty_view.dart';
import 'package:cockpit/core/widgets/app_error_view.dart';
import 'package:cockpit/core/widgets/app_icon.dart';
import 'package:cockpit/core/widgets/app_loader.dart';
import 'package:cockpit/core/widgets/app_scaffold.dart';
import 'package:cockpit/core/widgets/app_top_bar.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/presentation/controllers/connections_controller.dart';
import 'package:cockpit/features/connections/presentation/widgets/agent_row.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart';
import 'package:cockpit/features/triggers/presentation/widgets/run_agent_button.dart';

/// Connections screen.
class ConnectionsScreen extends ConsumerWidget {
  /// Creates the screen.
  const ConnectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final spacing = context.spacing;
    final agents = ref.watch(connectionsControllerProvider);
    // Agent Triggers (flag-gated): off → rows render exactly as before.
    final triggersOn = ref.watch(agentTriggersProvider);
    void openConnect() => context.goNamed(RouteNames.connectAgent);

    return AppScaffold(
      topBar: AppTopBar(
        title: l10n.connectionsTitle,
        trailing: AppButton(
          label: l10n.connect,
          icon: AppIcons.plus,
          onPressed: openConnect,
        ),
      ),
      body: switch (agents) {
        AsyncData(:final value) when value.isEmpty => AppEmptyView(
            icon: AppIcons.link,
            title: l10n.noAgentsTitle,
            message: l10n.noAgentsMessage,
            action: AppButton(
              label: l10n.connectAgent,
              icon: AppIcons.plus,
              onPressed: openConnect,
            ),
          ),
        AsyncData(:final value) => RefreshIndicator(
            color: context.colors.accent,
            backgroundColor: context.colors.surface,
            onRefresh: () {
              if (triggersOn) ref.invalidate(agentTriggersControllerProvider);
              return ref.refresh(connectionsControllerProvider.future);
            },
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.all(spacing.screenPadding),
              itemCount: value.length,
              separatorBuilder: (_, _) => SizedBox(height: spacing.cardGap),
              itemBuilder: (context, index) => triggersOn
                  ? _TriggerAwareAgentRow(key: ValueKey(value[index].id), agent: value[index])
                  : AgentRow(
                      key: ValueKey(value[index].id),
                      agent: value[index],
                      // TODO(feature/connections): agent detail (rotate secret, pause).
                    ),
            ),
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

/// Agent row with the Run control when the agent has an enabled trigger
/// (Agent Triggers; only built while the flag is on).
class _TriggerAwareAgentRow extends ConsumerWidget {
  const _TriggerAwareAgentRow({required this.agent, super.key});

  final Agent agent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trigger = ref.watch(enabledTriggerProvider(agent.id));
    if (trigger == null) return AgentRow(agent: agent);
    return AgentRow(
      agent: agent,
      footer: TriggerStatusLine(trigger: trigger),
      trailing: RunAgentButton(key: Key('run.${agent.id}'), agentId: agent.id),
    );
  }
}
