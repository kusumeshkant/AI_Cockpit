// Feature: agent_services · Layer: domain
// Use cases: list services, read the workspace's access, enable, disable.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';
import 'package:cockpit/features/agent_services/domain/repositories/agent_services_repository.dart';

/// Lists the services the app may show.
@lazySingleton
class ListServices {
  /// Creates the use case.
  const ListServices(this._repository);

  final AgentServicesRepository _repository;

  /// Active / paused services.
  Result<List<AgentService>> call() => _repository.listServices();
}

/// Reads the workspace's access to services.
@lazySingleton
class GetServiceAccess {
  /// Creates the use case.
  const GetServiceAccess(this._repository);

  final AgentServicesRepository _repository;

  /// One row per service the workspace ever enabled.
  Result<List<ServiceAccess>> call() => _repository.listAccess();
}

/// Enables a service (owner; built-in op `service.enable`).
@lazySingleton
class EnableService {
  /// Creates the use case.
  const EnableService(this._repository);

  final AgentServicesRepository _repository;

  /// Enables [slug] after the user accepted consent [consentVersion].
  Result<ServiceAccess> call({
    required String slug,
    required String consentVersion,
    required String requestId,
  }) =>
      _repository.enableService(slug: slug, consentVersion: consentVersion, requestId: requestId);
}

/// Disables a service (owner; built-in op `service.disable`).
@lazySingleton
class DisableService {
  /// Creates the use case.
  const DisableService(this._repository);

  final AgentServicesRepository _repository;

  /// Disables [slug].
  Result<ServiceAccess> call({required String slug, required String requestId}) =>
      _repository.disableService(slug: slug, requestId: requestId);
}
