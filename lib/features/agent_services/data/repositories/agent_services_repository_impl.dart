// Feature: agent_services · Layer: data
// AgentServicesRepository implementation. Errors map to Failures via `guard`.
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/error/error_mapper.dart';
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/agent_services/data/datasources/agent_services_ds.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';
import 'package:cockpit/features/agent_services/domain/repositories/agent_services_repository.dart';

/// Default [AgentServicesRepository].
@LazySingleton(as: AgentServicesRepository)
class AgentServicesRepositoryImpl implements AgentServicesRepository {
  /// Creates the repository.
  const AgentServicesRepositoryImpl(this._source);

  final AgentServicesDataSource _source;

  @override
  Result<List<AgentService>> listServices() => guard(_source.fetchServices);

  @override
  Result<List<ServiceAccess>> listAccess() => guard(_source.fetchAccess);

  @override
  Result<ServiceAccess> enableService({
    required String slug,
    required String consentVersion,
    required String requestId,
  }) =>
      guard(() => _source.enable(slug, consentVersion, requestId));

  @override
  Result<ServiceAccess> disableService({required String slug, required String requestId}) =>
      guard(() => _source.disable(slug, requestId));
}
