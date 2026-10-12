import 'package:dio/dio.dart';
import 'package:margnetra_super_app/core/app_constants/api_constants.dart';
import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/core/app_services/api_services/interceptors/auth_interceptor.dart';
import 'package:margnetra_super_app/core/app_services/api_services/interceptors/logging_interceptor.dart';

class ApiClient {
  static ApiClient? _instance;
  late final Dio dio;

  ApiClient._internal({String? customBaseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: customBaseUrl ?? ApiUrls.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        headers: {
          ApiConstants.contentTypeHeader: ApiConstants.jsonContentType,
          ApiConstants.acceptHeader: ApiConstants.jsonContentType,
        },
        responseType: ResponseType.json,
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      AuthInterceptor(),
      LoggingInterceptor(),
    ]);
  }

  static ApiClient get instance {
    _instance ??= ApiClient._internal();
    return _instance!;
  }

  /// Initialize with a custom base URL (e.g. for environment flavor or testing)
  static void init({String? baseUrl}) {
    _instance = ApiClient._internal(customBaseUrl: baseUrl);
  }

  /// Update base URL dynamically if user switches backend server
  void updateBaseUrl(String newBaseUrl) {
    dio.options.baseUrl = newBaseUrl;
    ApiUrls.baseUrl = newBaseUrl;
  }
}
