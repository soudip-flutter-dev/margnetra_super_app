import 'dart:developer' as developer;
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      '🌐 [DIO REQUEST] => ${options.method.toUpperCase()} ${options.uri}',
      name: 'Network',
    );
    if (options.headers.isNotEmpty) {
      developer.log('   Headers: ${options.headers}', name: 'Network');
    }
    if (options.queryParameters.isNotEmpty) {
      developer.log('   QueryParams: ${options.queryParameters}', name: 'Network');
    }
    if (options.data != null) {
      developer.log('   Body: ${options.data}', name: 'Network');
    }
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '✅ [DIO RESPONSE] <= ${response.statusCode} ${response.requestOptions.uri}',
      name: 'Network',
    );
    developer.log('   Data: ${response.data}', name: 'Network');
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '❌ [DIO ERROR] <= ${err.response?.statusCode} ${err.requestOptions.uri}',
      name: 'Network',
      error: err.error,
    );
    developer.log('   Message: ${err.message}', name: 'Network');
    if (err.response?.data != null) {
      developer.log('   Response Data: ${err.response?.data}', name: 'Network');
    }
    return handler.next(err);
  }
}
