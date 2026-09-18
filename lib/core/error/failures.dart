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

/// Anything not anticipated; always reported to Sentry.
final class UnexpectedFailure extends Failure {
  /// Creates an unexpected failure.
  const UnexpectedFailure([super.message = 'unexpected']);
}
