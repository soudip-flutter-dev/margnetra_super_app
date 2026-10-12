import 'package:dio/dio.dart';
import 'package:margnetra_super_app/core/app_exception_handler/app_exception_handler.dart';
import 'package:margnetra_super_app/core/app_services/api_services/api_client.dart';

class DataProvider {
  final Dio _dio;

  DataProvider({Dio? dio}) : _dio = dio ?? ApiClient.instance.dio;

  /// Helper to merge options with auth requirement flag
  Options _buildOptions(Options? options, bool requiresAuth) {
    final opts = options ?? Options();
    final extra = Map<String, dynamic>.from(opts.extra ?? {});
    extra['requiresAuth'] = requiresAuth;
    return opts.copyWith(extra: extra);
  }

  /// HTTP GET Request
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: _buildOptions(options, requiresAuth),
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
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(options, requiresAuth),
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
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(options, requiresAuth),
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
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(options, requiresAuth),
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
    bool requiresAuth = true,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(options, requiresAuth),
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
    bool requiresAuth = true,
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
        endpoint,
        data: formData,
        cancelToken: cancelToken,
        options: _buildOptions(Options(), requiresAuth),
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
}
