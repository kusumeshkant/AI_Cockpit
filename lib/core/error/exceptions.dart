// Exceptions thrown by datasources. They never cross the repository boundary:
// repositories convert them to failures via `guard` (error_mapper.dart).

/// Base type of datasource exceptions.
sealed class AppException implements Exception {
  /// Creates an exception with a developer-facing [message].
  const AppException(this.message);

  /// Developer-facing description.
  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

/// Backend returned a non-success response.
final class ServerException extends AppException {
  /// Creates a server exception.
  const ServerException(super.message, {this.statusCode});

  /// HTTP status code, when available.
  final int? statusCode;
}

/// Device offline or request timed out.
final class NetworkException extends AppException {
  /// Creates a network exception.
  const NetworkException(super.message);
}

/// Missing or invalid session. (Named to avoid clashing with Supabase's
/// `AuthException`.)
final class UnauthorizedException extends AppException {
  /// Creates an unauthorized exception.
  const UnauthorizedException(super.message);
}
