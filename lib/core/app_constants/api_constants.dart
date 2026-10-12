class ApiConstants {
  ApiConstants._();

  // Timeouts (set to 90s to accommodate Render backend cold starts)
  static const Duration connectTimeout = Duration(seconds: 90);
  static const Duration receiveTimeout = Duration(seconds: 90);
  static const Duration sendTimeout = Duration(seconds: 90);

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String bearerPrefix = 'Bearer ';
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  static const String jsonContentType = 'application/json';
  static const String multipartFormData = 'multipart/form-data';
}
