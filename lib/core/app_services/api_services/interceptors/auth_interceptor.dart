import 'package:dio/dio.dart';
import 'package:margnetra_super_app/core/app_constants/api_constants.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';

class AuthInterceptor extends Interceptor {
  final SharedPrefService _prefService;

  AuthInterceptor({SharedPrefService? prefService})
      : _prefService = prefService ?? SharedPrefService.instance;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Check if request allows skipping auth header
    final requiresAuth = options.extra['requiresAuth'] ?? true;

    if (requiresAuth) {
      final token = _prefService.getAuthToken();
      if (token != null && token.isNotEmpty) {
        options.headers[ApiConstants.authorizationHeader] =
            '${ApiConstants.bearerPrefix}$token';
      }
    }

    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized (token expired)
    if (err.response?.statusCode == 401) {
      // Clear current cached session
      await _prefService.clearAuthSession();
    }
    return handler.next(err);
  }
}
