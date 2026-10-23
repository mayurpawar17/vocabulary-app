import 'dart:developer' as developer;

/// Centralized logger wrapper using the `logger` package.
class AppLogger {
  AppLogger._(); // Private constructor to enforce static access

  //tags
  static const String _apiTag = 'API';
  static const String _debugTag = 'DEBUG';
  static const String _errorTag = 'ERROR';
  static const String _infoTag = 'INFO';
  static const String _successTag = 'SUCCESS';
  static const String _warningTag = 'WARNING';
  static const String _traceTag = 'TRACE';
  static const String _responseTag = 'RESPONSE';
  static const String _requestTag = 'REQUEST';
  static const String _headerTag = 'HEADER';

  static void apiUrl({
    String? tag,
    required String url,
  }) {
    developer.log("${tag ?? ''} $_apiTag: $url".trim());
  }

  static void headers({
    String? tag,
    required Map<String, dynamic> headers,
  }) {
    developer.log("${tag ?? ''} $_headerTag: $headers".trim());
  }

  static void response({
    String? tag,
    required String response,
  }) {
    developer.log("${tag ?? ''} $_responseTag: $response".trim());
  }

  static void request({
    String? tag,
    required String request,
  }) {
    developer.log("${tag ?? ''} $_requestTag: $request".trim());
  }

  static void info(String message, {String? tag}) {
    developer.log("${tag ?? ''} $_infoTag: $message".trim());
  }

  static void success(String message, {String? tag}) {
    developer.log("${tag ?? ''} $_successTag: $message".trim());
  }

  static void debug(String message, {String? tag}) {
    developer.log("${tag ?? ''} $_debugTag: $message".trim());
  }

  static void warning(String message, {String? tag}) {
    developer.log("${tag ?? ''} $_warningTag: $message".trim());
  }

  static void trace(String message, {String? tag}) {
    developer.log("${tag ?? ''} $_traceTag: $message".trim());
  }

  static void error(String message, {String? tag, Object? error, StackTrace? stackTrace}) {
    developer.log(
      "${tag ?? ''} $_errorTag: $message".trim(),
      error: error,
      stackTrace: stackTrace,
    );
  }
}