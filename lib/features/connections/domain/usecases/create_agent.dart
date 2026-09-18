// Feature: connections · Layer: domain
// Use case: create an agent connection and receive its one-time credentials.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/domain/agent_platform.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/connections/domain/entities/agent.dart';
import 'package:cockpit/features/connections/domain/repositories/connections_repository.dart';

/// Creates an agent.
@lazySingleton
class CreateAgent {
  /// Creates the use case.
  const CreateAgent(this._repository);

  final ConnectionsRepository _repository;

  /// Creates an agent named [name] on [platform], calling back to
  /// [callbackUrl].
  Result<AgentCredentials> call({
    required String name,
    required String callbackUrl,
    required AgentPlatform platform,
  }) {
    // TODO(feature/connections): validate name (1–60 chars) and https URL.
    return _repository.createAgent(
      name: name,
      callbackUrl: callbackUrl,
      platform: platform,
    );
  }
}
