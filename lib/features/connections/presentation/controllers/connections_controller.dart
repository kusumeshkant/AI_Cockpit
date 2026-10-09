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
import 'package:cockpit/features/connections/domain/repositories/connections_repository.dart';
import 'package:cockpit/features/connections/domain/usecases/create_agent.dart';
import 'package:cockpit/features/connections/domain/usecases/list_agents.dart';
import 'package:cockpit/features/connections/domain/usecases/send_test_action.dart';
import 'package:cockpit/features/triggers/presentation/controllers/trigger_controllers.dart'
    show getIsWorkspaceOwnerProvider;

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

/// The signed-in user's ownership, independent of any feature flag: `true`
/// owner, `false` known non-owner (approver), `null` not known (loading,
/// error, or no role source, e.g. widget tests).
final _isAgentManagerProvider = FutureProvider<bool?>((ref) async {
  ref.watch(authControllerProvider.select((auth) => auth.value?.id));
  try {
    final result = await ref.watch(getIsWorkspaceOwnerProvider)();
    return result.fold((_) => null, (isOwner) => isOwner);
  } on Object {
    return null;
  }
});

/// Whether agent-management entry points (Connect / Connect agent) are shown.
/// Agent management is owner-only on the backend; the UI hides it only once
/// the user is known not to be the owner, so an unknown role never blocks an
/// owner (the backend still answers 403 `forbidden`). Demo mode is the owner.
final canManageAgentsProvider = Provider<bool>(
  (ref) => ref.watch(_isAgentManagerProvider).value ?? true,
);

/// Whether "Send a test action" is offered: live backend only, since the
/// demo source has nothing to create the action in.
final testActionsSupportedProvider =
    Provider<bool>((ref) => getIt<ConnectionsRepository>().supportsTestActions);

/// Agents in the current workspace.
final connectionsControllerProvider =
    AsyncNotifierProvider<ConnectionsController, List<Agent>>(
  ConnectionsController.new,
);
