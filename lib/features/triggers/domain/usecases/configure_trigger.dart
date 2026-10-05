// Feature: triggers · Layer: domain
// Use case: create or reconfigure an agent's trigger (secret shown once).
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/triggers/domain/entities/agent_trigger.dart';
import 'package:cockpit/features/triggers/domain/repositories/trigger_repository.dart';

/// Configures an agent trigger.
@lazySingleton
class ConfigureTrigger {
  /// Creates the use case.
  const ConfigureTrigger(this._repository);

  final TriggerRepository _repository;

  /// Configures [agentId]'s trigger to POST to [triggerUrl].
  Result<TriggerCredentials> call({
    required String agentId,
    required String triggerUrl,
    int? minIntervalSecs,
  }) =>
      _repository.configureTrigger(
        agentId: agentId,
        triggerUrl: triggerUrl.trim(),
        minIntervalSecs: minIntervalSecs,
      );
}
