// Feature: agent_services · Layer: data
// Tolerant wire parsing for `agent_service` / `service_access` rows and the
// agent-proxy answer. Unknown enum values fall back safely and a missing
// optional never throws; only a missing identity (slug) is an error.
import 'package:cockpit/core/error/exceptions.dart';
import 'package:cockpit/features/agent_services/domain/entities/agent_service.dart';

/// Columns the app may select from `agent_service` (backend 0011 grants).
const String agentServiceColumns =
    'slug, display_name, description, icon, status, contract_version, min_app_version, ui, ui_schema_version';

/// Columns the app may select from `service_access` (backend 0011 grants).
const String serviceAccessColumns =
    'workspace_id, service_slug, agent_id, state, consent_version, consented_at, first_used_at, created_at, updated_at';

String? _string(Object? value) => value is String && value.isNotEmpty ? value : null;

int? _int(Object? value) => switch (value) {
      final int v => v,
      final num v when v == v.roundToDouble() => v.toInt(),
      _ => null,
    };

DateTime? _date(Object? value) => value is String ? DateTime.tryParse(value) : null;

T _enum<T extends Enum>(List<T> values, Object? wire, T fallback) =>
    values.firstWhere((v) => v.name == wire, orElse: () => fallback);

/// Parses an `agent_service` row.
AgentService agentServiceFromJson(Map<String, dynamic> json) {
  final slug = _string(json['slug']);
  if (slug == null) throw const ServerException('agent_service row without slug');
  return AgentService(
    slug: slug,
    displayName: _string(json['display_name']) ?? slug,
    description: _string(json['description']) ?? '',
    icon: _string(json['icon']),
    status: _enum(ServiceStatus.values, json['status'], ServiceStatus.unknown),
    contractVersion: _string(json['contract_version']) ?? '1.0',
    minAppVersion: _string(json['min_app_version']),
    ui: _enum(ServiceUi.values, json['ui'], ServiceUi.unknown),
    uiSchemaVersion: _int(json['ui_schema_version']) ?? 1,
  );
}

/// Parses a `service_access` row, or the result of `service.enable` /
/// `service.disable` (which carry no slug; pass [slug]).
ServiceAccess serviceAccessFromJson(Map<String, dynamic> json, {String? slug}) {
  final serviceSlug = _string(json['service_slug']) ?? slug;
  if (serviceSlug == null) throw const ServerException('service_access row without service_slug');
  return ServiceAccess(
    serviceSlug: serviceSlug,
    state: _enum(AccessState.values, json['state'], AccessState.unknown),
    consentVersion: _string(json['consent_version']),
    consentedAt: _date(json['consented_at']),
    firstUsedAt: _date(json['first_used_at']),
  );
}

/// Parses the `data` of an agent-proxy envelope. [accepted] is HTTP 202.
/// The result is passed on untouched; meta fields are type-checked.
GatewayResponse gatewayResponseFromJson(Map<String, dynamic> data, {required bool accepted}) {
  final meta = data['meta'] is Map ? Map<String, dynamic>.from(data['meta'] as Map) : const <String, dynamic>{};
  final requestId = _string(meta['request_id']);
  if (requestId == null) throw const ServerException('agent-proxy answer without request_id');
  final usage = meta['usage'] is Map ? Map<String, dynamic>.from(meta['usage'] as Map) : null;
  final used = usage == null ? null : _int(usage['used']);
  final poll = _int(meta['poll_after_ms']);
  return GatewayResponse(
    result: data['result'],
    accepted: accepted,
    meta: GatewayMeta(
      requestId: requestId,
      usage: used == null ? null : ServiceUsage(used: used, limit: _int(usage!['limit']), trialEndsAt: _date(usage['trial_ends_at'])),
      pollAfter: poll == null || poll < 0 ? null : Duration(milliseconds: poll),
      version: _string(meta['version']),
    ),
  );
}
