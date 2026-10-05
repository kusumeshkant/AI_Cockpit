// Feature: triggers · Layer: data
// TriggerRepository implementation. Every call goes through `guard`, which maps
// dio / PostgREST errors to typed Failures (incl. feature_disabled,
// trigger_disabled and rate_limited).
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/error/error_mapper.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/triggers/data/datasources/trigger_remote_ds.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/repositories/trigger_repository.dart';

/// Default [TriggerRepository].
@LazySingleton(as: TriggerRepository)
class TriggerRepositoryImpl implements TriggerRepository {
  /// Creates the repository.
  const TriggerRepositoryImpl(this._remote);

  final TriggerRemoteDataSource _remote;

  @override
  Result<List<AgentTrigger>> listTriggers() => guard(() async {
        final (triggers, lastRuns) = await (_remote.listTriggers(), _remote.lastRuns()).wait;
        return triggers
            .map((dto) => dto.toEntity(lastRunAt: lastRuns[dto.agentId]))
            .toList(growable: false);
      });

  @override
  Result<TriggerRun> runAgent(String agentId) =>
      guard(() async => (await _remote.runAgent(agentId)).toEntity());

  @override
  Result<TriggerCredentials> configureTrigger({
    required String agentId,
    required String triggerUrl,
    int? minIntervalSecs,
  }) =>
      guard(() async => (await _remote.configureTrigger(
            agentId: agentId,
            triggerUrl: triggerUrl,
            minIntervalSecs: minIntervalSecs,
          ))
              .toEntity());

  @override
  Result<AgentTrigger> setTriggerEnabled({
    required String agentId,
    required bool enabled,
  }) =>
      guard(() async =>
          (await _remote.setTriggerEnabled(agentId: agentId, enabled: enabled)).toEntity());
}
