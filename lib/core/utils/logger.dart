// Minimal structured logger. Routes to dart:developer so logs appear in
// DevTools; never log action payloads or personal data.
import 'dart:developer' as developer;

/// App-wide logger.
abstract final class AppLogger {
  static const String _name = 'cockpit';

  /// Logs a debug message.
  static void debug(String message) => developer.log(message, name: _name);

  /// Logs a warning.
  static void warning(String message) =>
      developer.log(message, name: _name, level: 900);

  /// Logs an error with optional [error] and [stackTrace].
  static void error(String message, [Object? error, StackTrace? stackTrace]) =>
      developer.log(
        message,
        name: _name,
        level: 1000,
        error: error,
        stackTrace: stackTrace,
      );
}
