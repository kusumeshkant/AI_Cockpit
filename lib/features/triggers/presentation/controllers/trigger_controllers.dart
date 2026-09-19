// Feature: triggers · Layer: presentation
// Agent Triggers state. Only watched while agentTriggersProvider is on, so
// with the flag off nothing here loads or runs.
//  * agentTriggersControllerProvider — the workspace's triggers by agent id.
//  * runAgentControllerProvider(agentId) — idle → running → success / error.
//    Taps while running are ignored (debounce); success shows briefly, then
//    returns to idle.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cockpit/core/di/injection.dart';
import 'package:cockpit/core/error/failures.dart';
import 'package:cockpit/features/auth/presentation/controllers/auth_controller.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/configure_trigger.dart';
import 'package:cockpit/features/triggers/domain/usecases/list_agent_triggers.dart';
import 'package:cockpit/features/triggers/domain/usecases/run_agent.dart';
import 'package:cockpit/features/triggers/domain/usecases/set_trigger_enabled.dart';

/// Use cases (overridable in tests).
final listAgentTriggersProvider = Provider<ListAgentTriggers>((ref) => getIt<ListAgentTriggers>());

/// [RunAgent] use case.
final runAgentUseCaseProvider = Provider<RunAgent>((ref) => getIt<RunAgent>());

/// [ConfigureTrigger] use case.
final configureTriggerProvider = Provider<ConfigureTrigger>((ref) => getIt<ConfigureTrigger>());

/// [SetTriggerEnabled] use case.
final setTriggerEnabledProvider = Provider<SetTriggerEnabled>((ref) => getIt<SetTriggerEnabled>());

/// Workspace triggers keyed by agent id.
class AgentTriggersController extends AsyncNotifier<Map<String, AgentTrigger>> {
  @override
  Future<Map<String, AgentTrigger>> build() async {
    ref.watch(authControllerProvider.select((auth) => auth.value?.id));
    final result = await ref.watch(listAgentTriggersProvider)();
    return result.fold(
      (failure) => throw failure,
      (triggers) => {for (final trigger in triggers) trigger.agentId: trigger},
    );
  }
}

/// The workspace's agent triggers.
final agentTriggersControllerProvider =
    AsyncNotifierProvider<AgentTriggersController, Map<String, AgentTrigger>>(
  AgentTriggersController.new,
);

/// [agentId]'s trigger when it exists and is enabled, else `null`.
final enabledTriggerProvider = Provider.family<AgentTrigger?, String>((ref, agentId) {
  final trigger = ref.watch(
    agentTriggersControllerProvider.select((triggers) => triggers.value?[agentId]),
  );
  return trigger != null && trigger.enabled ? trigger : null;
});

/// State of the Run button for one agent.
@immutable
sealed class RunAgentState {
  const RunAgentState();
}

/// Ready to run.
final class RunAgentIdle extends RunAgentState {
  /// Creates the state.
  const RunAgentIdle();
}

/// A run is in flight; further taps are ignored.
final class RunAgentRunning extends RunAgentState {
  /// Creates the state.
  const RunAgentRunning();
}

/// The agent acknowledged the trigger (shown briefly).
final class RunAgentSuccess extends RunAgentState {
  /// Creates the state.
  const RunAgentSuccess(this.run);

  /// The recorded run.
  final TriggerRun run;
}

/// The run failed or was refused ([failure]).
final class RunAgentError extends RunAgentState {
  /// Creates the state.
  const RunAgentError(this.failure);

  /// Why it failed.
  final Failure failure;
}

/// Runs one agent.
class RunAgentController extends Notifier<RunAgentState> {
  /// Creates the controller for [agentId].
  RunAgentController(this.agentId);

  /// How long the success state is shown before returning to idle.
  static const Duration successDisplay = Duration(seconds: 3);

  /// The agent this controller runs.
  final String agentId;

  Timer? _reset;

  @override
  RunAgentState build() {
    ref.onDispose(() => _reset?.cancel());
    return const RunAgentIdle();
  }

  /// Starts the agent. Ignored while a run is in flight.
  Future<void> run() async {
    if (state is RunAgentRunning) return;
    _reset?.cancel();
    state = const RunAgentRunning();

    final result = await ref.read(runAgentUseCaseProvider)(agentId);
    if (!ref.mounted) return;

    result.fold(
      (failure) => state = RunAgentError(failure),
      (run) {
        // The run is recorded either way; refresh "last run".
        ref.invalidate(agentTriggersControllerProvider);
        if (!run.delivered) {
          state = RunAgentError(ServerFailure(run.detail));
          return;
        }
        state = RunAgentSuccess(run);
        _reset = Timer(successDisplay, () {
          if (ref.mounted && state is RunAgentSuccess) state = const RunAgentIdle();
        });
      },
    );
  }
}

/// Run state per agent id.
final runAgentControllerProvider =
    NotifierProvider.family<RunAgentController, RunAgentState, String>(RunAgentController.new);
