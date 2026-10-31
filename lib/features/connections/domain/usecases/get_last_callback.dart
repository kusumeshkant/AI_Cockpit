// Feature: connections · Layer: domain
// Use case: the latest callback delivery to an agent (agent detail).
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/connections/domain/entities/callback_delivery.dart';
import 'package:cockpit/features/connections/domain/repositories/connections_repository.dart';

/// Reads an agent's latest callback delivery.
@lazySingleton
class GetLastCallback {
  /// Creates the use case.
  const GetLastCallback(this._repository);

  final ConnectionsRepository _repository;

  /// The latest delivery for [agentId], or `null` if none was attempted yet.
  Result<CallbackDelivery?> call(String agentId) => _repository.lastCallback(agentId);
}
