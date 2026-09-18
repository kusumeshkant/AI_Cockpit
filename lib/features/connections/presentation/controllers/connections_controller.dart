// Feature: connections · Layer: presentation
// Loads agents and runs create / test-action commands.
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/actions/presentation/controllers/actions_feed_controller.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/domain/usecases/create_agent.dart';
import 'package:cockpit/features/connections/domain/usecases/list_agents.dart';
import 'package:cockpit/features/connections/domain/usecases/send_test_action.dart';

/// Agents list controller.
class ConnectionsController extends AsyncNotifier<List<Agent>> {
  @override
  Future<List<Agent>> build() async {
    // Reload for a different signed-in user (tabs stay alive in the shell).
    ref.watch(authControllerProvider.select((auth) => auth.value?.id));
    final result = await getIt<ListAgents>()();
    return result.fold((failure) => throw failure, (agents) => agents);
  }

  /// Creates an agent. Returns its one-time credentials or a [Failure].
  Future<Either<Failure, AgentCredentials>> createAgent({
    required String name,
    required String callbackUrl,
    required AgentPlatform platform,
  }) async {
    final result = await getIt<CreateAgent>()(
      name: name,
      callbackUrl: callbackUrl,
      platform: platform,
    );
    if (result.isRight()) ref.invalidateSelf();
    return result;
  }

  /// Sends a test action for [agentId]. Returns `null` on success.
  Future<Failure?> sendTestAction(String agentId) async {
    final result = await getIt<SendTestAction>()(agentId);
    return result.fold((failure) => failure, (_) => null);
  }
}

/// Whether the actions feed holds an action from [agentId]. Resolves the
/// "waiting for your first action" banner after connecting an agent; the feed
/// updates live through Realtime + poll (TR-4).
final agentHasActionsProvider = Provider.family<bool, String>((ref, agentId) {
  final items = ref.watch(actionsFeedControllerProvider).value ?? const [];
  return items.any((item) => item.agentId == agentId);
});

/// Agents in the current workspace.
final connectionsControllerProvider =
    AsyncNotifierProvider<ConnectionsController, List<Agent>>(
  ConnectionsController.new,
);
