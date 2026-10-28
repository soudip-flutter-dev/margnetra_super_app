class ApiUrls {
  ApiUrls._();

  /// Change this to match your backend host:
  /// - For Android Emulator: http://10.0.2.2:8000
  /// - For iOS Simulator / Web / Desktop: http://127.0.0.1:8000
  /// - For Physical Device: `http://<YOUR_PC_LOCAL_IP>:8000`
  // static String baseUrl = 'http://10.0.2.2:8000';
  static String baseUrl = 'https://margentra-super-app-backend.onrender.com';

  // Auth endpoints
  static const String register = '/api/v1/auth/register';
  static const String login = '/api/v1/auth/login';
  static const String forgotPassword = '/api/v1/auth/forgot-password';
  static const String resetPassword = '/api/v1/auth/reset-password';
  static const String refreshToken = '/api/v1/auth/refresh';
  static const String logout = '/api/v1/auth/logout';

  // User endpoints
  static const String userProfile = '/api/v1/user/profile';
  static const String updateProfile = '/api/v1/user/profile';
  static const String userAvatar = '/api/v1/user/avatar';
  static const String userCivilScore = '/api/v1/user/civil-score';
  static const String userVehicles = '/api/v1/user/vehicles';
  static const String userPaymentMethods = '/api/v1/user/payment-methods';
  static const String userSettings = '/api/v1/user/settings';

  // MargNetra App specific endpoints
  static const String emergencySos = '/api/v1/sos/trigger';
  static const String bountyReports = '/api/v1/bounty/events';
}
