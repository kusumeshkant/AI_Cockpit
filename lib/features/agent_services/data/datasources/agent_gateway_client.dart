// Feature: agent_services · Layer: data
// The app's only way to talk to an agent service: POST agent-proxy (backend
// docs/agent-gateway-wire-v1.md). The caller owns the request id and the
// retry policy: this client never retries and never invents an id for a
// write. Bodies are never logged; failures surface as DioException and are
// mapped by `guard` (error_mapper.dart).
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:cockpit/core/config/api_endpoints.dart';
import 'package:cockpit/core/config/app_version.dart';
import 'package:cockpit/core/di/environments.dart';
import 'package:cockpit/core/network/dio_client.dart';
import 'package:cockpit/features/agent_services/data/models/agent_service_dto.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';

/// Calls service ops through `agent-proxy`.
@LazySingleton(env: [AppEnvironments.live])
class AgentGatewayClient {
  /// Creates the client.
  const AgentGatewayClient(this._client, this._version);

  final DioClient _client;
  final AppVersionSource _version;

  /// Calls [op] of [service]. [requestId] is sent as `Idempotency-Key`; it is
  /// required for write / destructive ops (the proxy refuses them without
  /// one) and optional for reads. HTTP 202 → `accepted`.
  Future<GatewayResponse> call({
    required String service,
    required String op,
    Map<String, Object?> params = const {},
    String? ifMatch,
    String? requestId,
  }) async {
    final response = await _client.dio.post<Object?>(
      ApiEndpoints.agentProxy,
      data: {
        'service': service,
        'op': op,
        if (params.isNotEmpty) 'params': params,
        'if_match': ?ifMatch,
      },
      options: Options(
        headers: {
          'X-App-Version': await _version.version(),
          'Idempotency-Key': ?requestId,
        },
      ),
    );
    return gatewayResponseFromJson(unwrapEnvelope(response.data), accepted: response.statusCode == 202);
  }
}
