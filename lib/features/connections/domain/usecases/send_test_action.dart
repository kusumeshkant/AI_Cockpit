// Feature: connections · Layer: domain
// Use case: send a sample action so the user sees the full flow immediately.
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/connections/domain/repositories/connections_repository.dart';

/// Sends a test action for an agent.
@lazySingleton
class SendTestAction {
  /// Creates the use case.
  const SendTestAction(this._repository);

  final ConnectionsRepository _repository;

  /// Sends a sample action for [agentId].
  Result<Unit> call(String agentId) => _repository.sendTestAction(agentId);
}
