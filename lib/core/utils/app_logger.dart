import 'dart:developer' as developer;

class AppLogger {
  static void logInfo(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'INFO',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void logWarning(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'WARNING',
      error: error,
      stackTrace: stackTrace,
    );
  }

  static void logError(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: 'ERROR',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
