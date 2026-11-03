// Feature: agent_services · Layer: domain
// Contract for listing services and switching them on / off. Implementations
// never throw; failures come back as a Failure.
import 'package:cockpit/core/utils/result.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';

/// Agent services access.
abstract interface class AgentServicesRepository {
  /// Services listed for the app (active / paused).
  Result<List<AgentService>> listServices();

  /// The workspace's access rows.
  Result<List<ServiceAccess>> listAccess();

  /// Turns [slug] on with consent [consentVersion]. [requestId] is reused when
  /// the same user action is retried.
  Result<ServiceAccess> enableService({
    required String slug,
    required String consentVersion,
    required String requestId,
  });

  /// Turns [slug] off.
  Result<ServiceAccess> disableService({required String slug, required String requestId});
}
