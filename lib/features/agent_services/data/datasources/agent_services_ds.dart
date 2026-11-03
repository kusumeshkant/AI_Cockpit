// Feature: agent_services · Layer: data
// Services and the workspace's access: RLS-scoped reads of `agent_service`
// (active / paused only) and `service_access` (own workspace only), plus the
// proxy's built-in ops `service.enable` / `service.disable`. Demo mode keeps
// two fake services in memory.
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:cockpit/core/config/api_endpoints.dart';
import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/features/agent_services/data/datasources/agent_gateway_client.dart';
import 'package:cockpit/features/agent_services/data/models/agent_service_dto.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';

/// Source of services and access; throws on failure (mapped by the repository).
abstract interface class AgentServicesDataSource {
  /// Listed services.
  Future<List<AgentService>> fetchServices();

  /// The workspace's access rows.
  Future<List<ServiceAccess>> fetchAccess();

  /// `service.enable` with [consentVersion].
  Future<ServiceAccess> enable(String slug, String consentVersion, String requestId);

  /// `service.disable`.
  Future<ServiceAccess> disable(String slug, String requestId);
}

/// Supabase + agent-proxy implementation.
@LazySingleton(as: AgentServicesDataSource, env: [AppEnvironments.live])
class AgentServicesRemoteDataSource implements AgentServicesDataSource {
  /// Creates the datasource.
  const AgentServicesRemoteDataSource(this._client, this._gateway);

  final SupabaseClient _client;
  final AgentGatewayClient _gateway;

  @override
  Future<List<AgentService>> fetchServices() async {
    final rows = await _client.from(DbTables.agentService).select(agentServiceColumns).order('display_name');
    return [for (final row in rows) agentServiceFromJson(row)];
  }

  @override
  Future<List<ServiceAccess>> fetchAccess() async {
    final rows = await _client.from(DbTables.serviceAccess).select(serviceAccessColumns);
    return [for (final row in rows) serviceAccessFromJson(row)];
  }

  @override
  Future<ServiceAccess> enable(String slug, String consentVersion, String requestId) =>
      _builtIn(slug, 'service.enable', {'consent_version': consentVersion}, requestId);

  @override
  Future<ServiceAccess> disable(String slug, String requestId) =>
      _builtIn(slug, 'service.disable', const {}, requestId);

  Future<ServiceAccess> _builtIn(String slug, String op, Map<String, Object?> params, String requestId) async {
    final response = await _gateway.call(service: slug, op: op, params: params, requestId: requestId);
    final result = response.result;
    return serviceAccessFromJson(result is Map ? Map<String, dynamic>.from(result) : const {}, slug: slug);
  }
}

/// Demo implementation: one enabled service, one not.
@LazySingleton(as: AgentServicesDataSource, env: [AppEnvironments.demo])
class AgentServicesDemoDataSource implements AgentServicesDataSource {
  /// Creates the datasource with the seeded services.
  AgentServicesDemoDataSource();

  /// Seeded services.
  static const List<AgentService> services = [
    AgentService(
      slug: 'content-creator',
      displayName: 'Content creator',
      description: 'Drafts social posts for your review.',
      icon: 'sparkles',
      status: ServiceStatus.active,
      ui: ServiceUi.native,
    ),
    AgentService(
      slug: 'inbox-helper',
      displayName: 'Inbox helper',
      description: 'Suggests replies to customer emails.',
      icon: 'mail',
      status: ServiceStatus.active,
      ui: ServiceUi.native,
    ),
  ];

  final Map<String, ServiceAccess> _access = {
    'content-creator': ServiceAccess(
      serviceSlug: 'content-creator',
      state: AccessState.active,
      consentVersion: currentServiceConsentVersion,
      consentedAt: DateTime.utc(2026, 10, 1),
    ),
  };

  @override
  Future<List<AgentService>> fetchServices() async => services;

  @override
  Future<List<ServiceAccess>> fetchAccess() async => List.unmodifiable(_access.values);

  @override
  Future<ServiceAccess> enable(String slug, String consentVersion, String requestId) async =>
      _access[slug] = ServiceAccess(
        serviceSlug: slug,
        state: AccessState.active,
        consentVersion: consentVersion,
        consentedAt: DateTime.now().toUtc(),
      );

  @override
  Future<ServiceAccess> disable(String slug, String requestId) async {
    final current = _access[slug];
    return _access[slug] = (current ?? ServiceAccess(serviceSlug: slug)).copyWith(state: AccessState.disabled);
  }
}
