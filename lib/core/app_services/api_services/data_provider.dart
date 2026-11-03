import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:margnetra_super_app/core/app_constants/api_constants.dart';
import 'package:margnetra_super_app/core/app_exception_handler/app_exception_handler.dart';
import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/refresh_tokan_model/refresh_tokan_response.dart';

class DataProvider {
  // ──────────────────────────────────────────────────────────────
  // Guard flag – prevents a concurrent 401 from triggering a
  // second refresh while one is already in flight.
  // ──────────────────────────────────────────────────────────────
  bool _isRefreshing = false;

  final SharedPrefService _prefService;

  late final Dio _dio;

  DataProvider({SharedPrefService? prefService, Dio? dio})
      : _prefService = prefService ?? SharedPrefService.instance {
    _dio = dio ??
        Dio(
          BaseOptions(
            baseUrl: ApiUrls.baseUrl,
            connectTimeout: ApiConstants.connectTimeout,
            receiveTimeout: ApiConstants.receiveTimeout,
            sendTimeout: ApiConstants.sendTimeout,
            headers: {
              ApiConstants.contentTypeHeader: ApiConstants.jsonContentType,
              ApiConstants.acceptHeader: ApiConstants.jsonContentType,
            },
            responseType: ResponseType.json,
            // Pass 401s to onError so the refresh interceptor can handle them.
            validateStatus: (status) =>
                status != null && status >= 200 && status < 300,
          ),
        );

    _dio.interceptors.add(
      InterceptorsWrapper(
        // ── onRequest ──────────────────────────────────────────
        onRequest: (options, handler) {
          developer.log(
            '🌐 [DIO REQUEST] => ${options.method.toUpperCase()} ${options.uri}',
            name: 'Network',
          );

          // Auth endpoints never receive the Bearer token.
          final isAuthRequest =
              options.path.endsWith(ApiUrls.login) ||
              options.path.endsWith(ApiUrls.register) ||
              options.path.endsWith(ApiUrls.refreshToken) ||
              options.path.endsWith(ApiUrls.forgotPassword) ||
              options.path.endsWith(ApiUrls.resetPassword);

          if (!isAuthRequest) {
            final token = _prefService.getAuthToken();
            if (token != null && token.isNotEmpty) {
              options.headers[ApiConstants.authorizationHeader] =
                  '${ApiConstants.bearerPrefix}$token';
            }
          }

          handler.next(options);
        },

        // ── onResponse ─────────────────────────────────────────
        onResponse: (response, handler) {
          developer.log(
            '✅ [DIO RESPONSE] <= ${response.statusCode} ${response.requestOptions.uri}',
            name: 'Network',
          );
          handler.next(response);
        },

        // ── onError ────────────────────────────────────────────
        onError: (error, handler) async {
          developer.log(
            '❌ [DIO ERROR] <= ${error.response?.statusCode} ${error.requestOptions.uri}',
            name: 'Network',
            error: error.error,
          );
          if (error.response?.data != null) {
            developer.log('   Response Data: ${error.response?.data}',
                name: 'Network');
          }

          final isAuthRequest =
              error.requestOptions.path.endsWith(ApiUrls.login) ||
              error.requestOptions.path.endsWith(ApiUrls.register) ||
              error.requestOptions.path.endsWith(ApiUrls.refreshToken) ||
              error.requestOptions.path.endsWith(ApiUrls.forgotPassword) ||
              error.requestOptions.path.endsWith(ApiUrls.resetPassword) ||
              error.requestOptions.path.endsWith(ApiUrls.logout);

          // ── 401 handling: attempt a token refresh ───────────
          if (error.response?.statusCode == 401 &&
              !_isRefreshing &&
              !isAuthRequest) {
            _isRefreshing = true;
            final newAccessToken = await _callRefreshTokenApi();
            _isRefreshing = false;

            if (newAccessToken != null) {
              // Retry the original request with the refreshed token.
              final retryOptions = error.requestOptions;
              retryOptions.headers[ApiConstants.authorizationHeader] =
                  '${ApiConstants.bearerPrefix}$newAccessToken';
              try {
                final retryResponse = await _dio.fetch(retryOptions);
                return handler.resolve(retryResponse);
              } catch (_) {
                // If retry also fails, fall through to normal error handling.
              }
            } else {
              // Refresh failed – wipe the stale session.
              await _prefService.clearAuthSession();
            }
          }

          // Any 401 on a non-auth endpoint with no successful refresh:
          // clear session so the app can redirect to login.
          if (error.response?.statusCode == 401 && !isAuthRequest) {
            await _prefService.clearAuthSession();
          }

          handler.next(error);
        },
      ),
    );
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Internal helpers
  // ────────────────────────────────────────────────────────────────────────────

  /// Calls `POST /api/auth/refresh`, stores the new tokens and returns the
  /// new access token string on success, or `null` on failure.
  Future<String?> _callRefreshTokenApi() async {
    developer.log('🔄 [REFRESH TOKEN] => Attempting token refresh…',
        name: 'Network');
    try {
      final storedRefreshToken = _prefService.getRefreshToken();
      if (storedRefreshToken == null || storedRefreshToken.isEmpty) {
        developer.log(
          '⚠️ [REFRESH TOKEN] No stored refresh token. Skipping refresh.',
          name: 'Network',
        );
        return null;
      }

      final response = await _dio.post(
        '${ApiUrls.baseUrl}${ApiUrls.refreshToken}',
        data: {'refreshToken': storedRefreshToken},
        options: Options(
          headers: {
            ApiConstants.contentTypeHeader: ApiConstants.jsonContentType,
          },
          // Do NOT validate via the interceptor chain – use raw status check.
          extra: {'skipAuthInterceptor': true},
        ),
      );

      developer.log(
        '🔄 [REFRESH TOKEN] Response: ${response.data}',
        name: 'Network',
      );

      if (response.statusCode == 200 &&
          response.data != null &&
          response.data is Map<String, dynamic>) {
        final result = RefreshTokanResponse.fromJson(
          response.data as Map<String, dynamic>,
        );

        final newAccessToken = result.data?.accessToken;
        final newRefreshToken = result.data?.refreshToken;

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          await _prefService.saveAuthToken(newAccessToken);
          await _prefService.setLoggedIn(true);
        }
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await _prefService.saveRefreshToken(newRefreshToken);
        }

        return newAccessToken;
      }

      return null;
    } catch (e) {
      developer.log(
        '❌ [REFRESH TOKEN] Failed: $e',
        name: 'Network',
        error: e,
      );
      return null;
    }
  }

  // ────────────────────────────────────────────────────────────────────────────
  // Public API methods
  // ────────────────────────────────────────────────────────────────────────────

  /// HTTP GET Request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiUrls.baseUrl}$endpoint',
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw AppExceptionHandler.fromDioException(e);
    } on AppExceptionHandler {
      rethrow;
    } catch (e) {
      throw FetchDataException(msg: e.toString());
    }
  }

  /// HTTP POST Request
  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiUrls.baseUrl}$endpoint',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw AppExceptionHandler.fromDioException(e);
    } on AppExceptionHandler {
      rethrow;
    } catch (e) {
      throw FetchDataException(msg: e.toString());
    }
  }

  /// HTTP PUT Request
  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.put(
        '${ApiUrls.baseUrl}$endpoint',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw AppExceptionHandler.fromDioException(e);
    } on AppExceptionHandler {
      rethrow;
    } catch (e) {
      throw FetchDataException(msg: e.toString());
    }
  }

  /// HTTP PATCH Request
  Future<dynamic> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.patch(
        '${ApiUrls.baseUrl}$endpoint',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw AppExceptionHandler.fromDioException(e);
    } on AppExceptionHandler {
      rethrow;
    } catch (e) {
      throw FetchDataException(msg: e.toString());
    }
  }

  /// HTTP DELETE Request
  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        '${ApiUrls.baseUrl}$endpoint',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      throw AppExceptionHandler.fromDioException(e);
    } on AppExceptionHandler {
      rethrow;
    } catch (e) {
      throw FetchDataException(msg: e.toString());
    }
  }

  /// File Upload using Multipart/FormData
  Future<dynamic> uploadFile(
    String endpoint, {
    required String filePath,
    required String fileFieldName,
    Map<String, dynamic>? additionalFields,
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
  }) async {
    try {
      final fileName = filePath.split(RegExp(r'[/\\]')).last;
      final file = await MultipartFile.fromFile(filePath, filename: fileName);

      final Map<String, dynamic> formMap = {
        fileFieldName: file,
        if (additionalFields != null) ...additionalFields,
      };

      final formData = FormData.fromMap(formMap);

      final response = await _dio.post(
        '${ApiUrls.baseUrl}$endpoint',
        data: formData,
        cancelToken: cancelToken,
        options: Options(
          headers: {
            ApiConstants.contentTypeHeader: ApiConstants.multipartFormData,
          },
        ),
        onSendProgress: onSendProgress,
      );
      return response.data;
    } on DioException catch (e) {
      throw AppExceptionHandler.fromDioException(e);
    } on AppExceptionHandler {
      rethrow;
    } catch (e) {
      throw FetchDataException(msg: e.toString());
    }
  }

  /// Public refresh-token method — delegates to [_callRefreshTokenApi] and
  /// returns the full typed [RefreshTokanResponse] for use in the repository layer.
  ///
  /// Pass [refreshTokan] to override the stored token; leave it `null` to use
  /// the value already saved in [SharedPrefService].
  Future<RefreshTokanResponse> refreshTokan({String? refreshTokan}) async {
    try {
      final storedToken =
          refreshTokan ?? _prefService.getRefreshToken() ?? '';

      final response = await _dio.post(
        '${ApiUrls.baseUrl}${ApiUrls.refreshToken}',
        data: {'refreshToken': storedToken},
        options: Options(
          headers: {
            ApiConstants.contentTypeHeader: ApiConstants.jsonContentType,
          },
        ),
      );

      final result = RefreshTokanResponse.fromJson(
        response.data is Map<String, dynamic>
            ? response.data as Map<String, dynamic>
            : <String, dynamic>{},
      );

      // Persist the new tokens automatically.
      final newAccessToken = result.data?.accessToken;
      final newRefreshToken = result.data?.refreshToken;

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        await _prefService.saveAuthToken(newAccessToken);
        await _prefService.setLoggedIn(true);
      }
      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await _prefService.saveRefreshToken(newRefreshToken);
      }

      return result;
    } on DioException catch (e) {
      throw AppExceptionHandler.fromDioException(e);
    } on AppExceptionHandler {
      rethrow;
    } catch (e) {
      throw FetchDataException(msg: e.toString());
    }
  }
}
