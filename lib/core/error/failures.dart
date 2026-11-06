// Typed failures returned through Either<Failure, T>. Pure Dart: safe for the
// domain layer. Presentation maps each subtype to a localized message.

/// Base type of every expected failure.
sealed class Failure {
  /// Creates a failure with a developer-facing [message].
  const Failure(this.message);

  /// Developer-facing description (never shown to users directly).
  final String message;

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType &&
      other is Failure &&
      other.message == message;

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() => '$runtimeType($message)';
}

/// No connectivity or a timeout.
final class NetworkFailure extends Failure {
  /// Creates a network failure.
  const NetworkFailure([super.message = 'network']);
}

/// The backend returned an error response.
final class ServerFailure extends Failure {
  /// Creates a server failure with an optional HTTP [statusCode].
  const ServerFailure([super.message = 'server', this.statusCode]);

  /// HTTP status code, when available.
  final int? statusCode;
}

/// The session is missing, expired or not permitted.
final class AuthFailure extends Failure {
  /// Creates an auth failure.
  const AuthFailure([super.message = 'auth']);
}

/// The target changed state concurrently (HTTP 409), e.g. an action was
/// already decided elsewhere.
final class ConflictFailure extends Failure {
  /// Creates a conflict failure.
  const ConflictFailure([super.message = 'conflict']);
}

/// The target is no longer actionable (HTTP 410), e.g. an expired action.
final class ExpiredFailure extends Failure {
  /// Creates an expired failure.
  const ExpiredFailure([super.message = 'expired']);
}

/// The request was rejected as invalid (HTTP 422, bad OTP code…).
final class ValidationFailure extends Failure {
  /// Creates a validation failure.
  const ValidationFailure([super.message = 'validation']);
}

/// Too many requests (HTTP 429 `rate_limited`); retry after [retryAfter].
final class RateLimitedFailure extends Failure {
  /// Creates a rate-limit failure.
  const RateLimitedFailure([super.message = 'rate_limited', this.retryAfter]);

  /// Server hint from `Retry-After`, when present.
  final Duration? retryAfter;
}

/// The feature is switched off on the backend (HTTP 404 `feature_disabled`),
/// e.g. Agent Triggers while FEATURE_AGENT_TRIGGERS is unset.
final class FeatureDisabledFailure extends Failure {
  /// Creates a feature-disabled failure.
  const FeatureDisabledFailure([super.message = 'feature_disabled']);
}

/// The agent's trigger exists but is disabled (HTTP 409 `trigger_disabled`).
final class TriggerDisabledFailure extends Failure {
  /// Creates a trigger-disabled failure.
  const TriggerDisabledFailure([super.message = 'trigger_disabled']);
}

/// The signed-in user's role may not do this (HTTP 403 `forbidden`), e.g. an
/// approver connecting an agent. Agent management is owner-only.
final class ForbiddenFailure extends Failure {
  /// Creates a forbidden failure.
  const ForbiddenFailure([super.message = 'forbidden']);
}

/// The agent is disabled (HTTP 403 `agent_disabled`). Not a lost session.
final class AgentDisabledFailure extends Failure {
  /// Creates an agent-disabled failure.
  const AgentDisabledFailure([super.message = 'agent_disabled']);
}

/// The thing asked for no longer exists or isn't visible to this user
/// (HTTP 404 `not_found`), e.g. an agent deleted elsewhere.
final class NotFoundFailure extends Failure {
  /// Creates a not-found failure.
  const NotFoundFailure([super.message = 'not_found']);
}

// -----------------------------------------------------------------------------
// Agent services gateway (backend 0011–0014; agent-gateway-wire-v1.md). The
// codes come from the envelope's `error.code`.
// -----------------------------------------------------------------------------

/// The service can't be reached right now (503 `agent_unavailable`);
/// retry after [retryAfter].
final class AgentUnavailableFailure extends Failure {
  /// Creates the failure.
  const AgentUnavailableFailure([super.message = 'agent_unavailable', this.retryAfter]);

  /// Server hint from `Retry-After`, when present.
  final Duration? retryAfter;
}

/// The service took too long (504 `agent_timeout`).
final class AgentTimeoutFailure extends Failure {
  /// Creates the failure.
  const AgentTimeoutFailure([super.message = 'agent_timeout']);
}

/// The service answered something unexpected (502 `agent_error`). Never
/// carries the service's own text.
final class AgentErrorFailure extends Failure {
  /// Creates the failure.
  const AgentErrorFailure([super.message = 'agent_error']);
}

/// The service is paused (503 `agent_paused`).
final class AgentPausedFailure extends Failure {
  /// Creates the failure.
  const AgentPausedFailure([super.message = 'agent_paused']);
}

/// The service's trial is over (403 `trial_ended`).
final class TrialEndedFailure extends Failure {
  /// Creates the failure.
  const TrialEndedFailure([super.message = 'trial_ended']);
}

/// The service's usage limit is reached (403 `quota_reached`).
final class QuotaReachedFailure extends Failure {
  /// Creates the failure.
  const QuotaReachedFailure([super.message = 'quota_reached']);
}

/// The service won't approve this yet (422 `approval_blocked`).
final class ApprovalBlockedFailure extends Failure {
  /// Creates the failure.
  const ApprovalBlockedFailure([super.message = 'approval_blocked']);
}

/// The service doesn't offer this operation (422 `unsupported_op`).
final class UnsupportedOpFailure extends Failure {
  /// Creates the failure.
  const UnsupportedOpFailure([super.message = 'unsupported_op']);
}

/// This app version is too old for the service (426 `app_update_required`).
final class AppUpdateRequiredFailure extends Failure {
  /// Creates the failure.
  const AppUpdateRequiredFailure([super.message = 'app_update_required']);
}

/// The service doesn't exist or isn't offered (404 `service_not_found`).
final class ServiceNotFoundFailure extends Failure {
  /// Creates the failure.
  const ServiceNotFoundFailure([super.message = 'service_not_found']);
}

/// The service isn't enabled — or available — for this workspace (403
/// `service_not_enabled`; blocked access looks the same).
final class ServiceNotEnabledFailure extends Failure {
  /// Creates the failure.
  const ServiceNotEnabledFailure([super.message = 'service_not_enabled']);
}

/// The idea was already decided on the service's side (409 `conflict` with
/// `details.code == 'idea_final'`).
final class IdeaFinalFailure extends Failure {
  /// Creates the failure.
  const IdeaFinalFailure([super.message = 'idea_final']);
}

/// Whether repeating the same request may succeed: the network failed, the
/// server answered 5xx (or gave no status), or the service was unreachable /
/// too slow. Never for answers that describe the request itself — already
/// decided (409), expired (410), invalid, forbidden, not found, rate limited,
/// trial over, quota reached.
bool isRetryable(Failure failure) => switch (failure) {
      NetworkFailure() => true,
      ServerFailure(:final statusCode) => statusCode == null || statusCode >= 500,
      AgentUnavailableFailure() || AgentTimeoutFailure() => true,
      _ => false,
    };

/// Anything not anticipated; always reported to Sentry.
final class UnexpectedFailure extends Failure {
  /// Creates an unexpected failure.
  const UnexpectedFailure([super.message = 'unexpected']);
}
