// Feature: agent_services · Layer: domain
// A Cockpit-hosted agent service (backend `agent_service`, 0011) as the app
// may see it, the workspace's access to it, and what the two mean together.
// Pure Dart.
import 'package:freezed_annotation/freezed_annotation.dart';

part 'agent_service.freezed.dart';

/// Registry status the app can see (RLS lists active / paused only).
enum ServiceStatus {
  /// Available.
  active,

  /// Temporarily paused by the operator.
  paused,

  /// Anything else (treated as unavailable).
  unknown,
}

/// How the service's screens are built.
enum ServiceUi {
  /// Native Flutter screens.
  native,

  /// Server-driven UI.
  sdui,

  /// Not known to this app version.
  unknown,
}

/// The workspace's access state for a service.
enum AccessState {
  /// Enabled.
  active,

  /// Disabled by the owner.
  disabled,

  /// Blocked by the operator (shown exactly like "not available").
  blocked,

  /// Not known to this app version (shown like "not available").
  unknown,
}

/// A listed service.
@freezed
abstract class AgentService with _$AgentService {
  /// Creates an [AgentService].
  const factory AgentService({
    required String slug,
    required String displayName,
    @Default('') String description,
    String? icon,
    @Default(ServiceStatus.unknown) ServiceStatus status,
    @Default('1.0') String contractVersion,
    String? minAppVersion,
    @Default(ServiceUi.unknown) ServiceUi ui,
    @Default(1) int uiSchemaVersion,
  }) = _AgentService;
}

/// The workspace's access to one service.
@freezed
abstract class ServiceAccess with _$ServiceAccess {
  /// Creates a [ServiceAccess].
  const factory ServiceAccess({
    required String serviceSlug,
    @Default(AccessState.unknown) AccessState state,
    String? consentVersion,
    DateTime? consentedAt,
    DateTime? firstUsedAt,
  }) = _ServiceAccess;
}

/// What the owner sees for a service.
enum ServiceAvailability {
  /// Listed and not enabled for this workspace.
  notEnabled,

  /// Enabled and available.
  enabled,

  /// Enabled, but the operator paused the service.
  paused,

  /// Not available for this account (blocked, or a state this app doesn't
  /// know). Never says why.
  unavailable,
}

/// A service with the workspace's access (none = never enabled).
@freezed
abstract class ServiceListing with _$ServiceListing {
  /// Creates a [ServiceListing].
  const factory ServiceListing({required AgentService service, ServiceAccess? access}) = _ServiceListing;

  const ServiceListing._();

  /// The state shown to the owner.
  ServiceAvailability get availability {
    if (service.status == ServiceStatus.unknown) return ServiceAvailability.unavailable;
    switch (access?.state) {
      case null:
      case AccessState.disabled:
        return ServiceAvailability.notEnabled;
      case AccessState.blocked:
      case AccessState.unknown:
        return ServiceAvailability.unavailable;
      case AccessState.active:
        return service.status == ServiceStatus.paused ? ServiceAvailability.paused : ServiceAvailability.enabled;
    }
  }
}

/// Usage reported by a service (meta.usage).
@freezed
abstract class ServiceUsage with _$ServiceUsage {
  /// Creates a [ServiceUsage].
  const factory ServiceUsage({required int used, int? limit, DateTime? trialEndsAt}) = _ServiceUsage;
}

/// The gateway's `meta` (agent-proxy).
@freezed
abstract class GatewayMeta with _$GatewayMeta {
  /// Creates [GatewayMeta].
  const factory GatewayMeta({
    required String requestId,
    ServiceUsage? usage,
    Duration? pollAfter,
    String? version,
  }) = _GatewayMeta;
}

/// One agent-proxy answer. [accepted] is true for HTTP 202 (a job was
/// accepted; poll for its result).
@freezed
abstract class GatewayResponse with _$GatewayResponse {
  /// Creates a [GatewayResponse].
  const factory GatewayResponse({
    required Object? result,
    required GatewayMeta meta,
    @Default(false) bool accepted,
  }) = _GatewayResponse;
}

/// The consent text version the app shows before enabling a service.
const String currentServiceConsentVersion = 'v1';
