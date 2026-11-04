class ApiUrls {
  ApiUrls._();

  /// Change this to match your backend host:
  /// - For Android Emulator: http://10.0.2.2:8000
  /// - For iOS Simulator / Web / Desktop: http://127.0.0.1:8000
  /// - For Physical Device: `http://<YOUR_PC_LOCAL_IP>:8000`
  // static String baseUrl = 'http://10.0.2.2:8000';
  // static String baseUrlPy = 'https://margentra-super-app-backend.onrender.com';
  static String baseUrl = 'https://margentrabackend.onrender.com';

  // ── Auth endpoints ─────────────────────────────────────────────────────────
  static const String register = '/api/auth/register';
  static const String login = '/api/auth/login';
  static const String logout = '/api/auth/logout';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String refreshToken = '/api/auth/refresh';

// ------vehicle api--------------
   static const String vehicleRegistration = "/api/vehicles";

  //  ----------vehicle document section--------------
  static const String vehicleDocuments = "/api/documents";
  // ── Profile / User endpoints ───────────────────────────────────────────────
  static const String userProfile = '/api/auth/me';
  
  // ── Telemetry WebSocket endpoints ──────────────────────────────────────────
  static const String defaultTelemetryToken =
      'eyJhbGciOiJIUzM4NCJ9.eyJzdWIiOiJhOGE0OWU3Yy05Y2YyLTRjZDEtOTc3ZC04OWM3NTAzYWVhZjUiLCJlbWFpbCI6ImNoYW5kc2lAZ21haWwuY29tIiwiZnVsbE5hbWUiOiJDaGFuZHNpIFNvbGFua2kiLCJpc3MiOiJtYXJnZW50cmEtYmFja2VuZCIsImlhdCI6MTc5MzYwMzAzMCwiZXhwIjoxNzkzNjAzOTMwfQ.b8rZHdORLK9UXbfKXHFDWimwBwbq2sVUNcG0LsWnIiP0VbiR2cjZCqh0J2ClZOix';

  static const String defaultTelemetryVehicleId =
      'ee344c8c-b968-421e-a3ed-65a0e6c9aa81';

  static const String telemetrySocketBase =
      'wss://margentrabackend.onrender.com/ws/telemetry';
  static const String telemetrySocketLocal =
      'ws://localhost:8080/ws/telemetry';
  static const String telemetrySocketEmulator =
      'ws://10.0.2.2:8080/ws/telemetry';

  static String getTelemetrySocketUrl({String? baseUrl, String? token}) {
    final base = baseUrl ?? telemetrySocketBase;
    final normalized = base.startsWith('https://')
        ? 'wss://${base.substring(8)}'
        : base.startsWith('http://')
            ? 'ws://${base.substring(7)}'
            : base;

    final t = token ?? defaultTelemetryToken;
    final separator = normalized.contains('?') ? '&' : '?';
    return '$normalized${separator}token=$t';
  }

  // ── MargNetra App specific endpoints ──────────────────────────────────────
  
}
