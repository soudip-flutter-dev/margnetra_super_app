import 'package:dio/dio.dart';

class AppExceptionHandler implements Exception {
  final String exTitle;
  final String exMsg;
  final int? statusCode;

  AppExceptionHandler({
    required this.exTitle,
    required this.exMsg,
    this.statusCode,
  });

  @override
  String toString() {
    return "$exTitle: $exMsg";
  }

  /// Factory to map DioException into structured, user-friendly domain exceptions
  factory AppExceptionHandler.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          msg: "Request timed out. The server may be taking longer to wake up. Please try again.",
        );

      case DioExceptionType.badCertificate:
        return AppExceptionHandler(
          exTitle: "Certificate Error",
          exMsg: "Untrusted server certificate encountered.",
        );

      case DioExceptionType.badResponse:
        return AppExceptionHandler.fromResponse(
          dioException.response?.statusCode,
          dioException.response?.data,
        );

      case DioExceptionType.cancel:
        return AppExceptionHandler(
          exTitle: "Request Cancelled",
          exMsg: "The network request was cancelled.",
        );

      case DioExceptionType.connectionError:
        return NoInternetException(
          msg: "Unable to reach the server. Please check your internet connection.",
        );

      case DioExceptionType.unknown:
      default:
        return FetchDataException(
          msg: dioException.message ?? "An unexpected network error occurred.",
        );
    }
  }

  /// Maps HTTP status codes and response bodies (including FastAPI format)
  factory AppExceptionHandler.fromResponse(int? statusCode, dynamic data) {
    final errorMessage = _extractMessage(data);

    switch (statusCode) {
      case 400:
        return BadRequestException(
          msg: errorMessage ?? "Invalid request sent to server.",
          statusCode: 400,
        );
      case 401:
        return UnauthorizedException(
          msg: errorMessage ?? "Authentication failed. Please login again.",
          statusCode: 401,
        );
      case 403:
        return ForbiddenException(
          msg: errorMessage ?? "You do not have permission to perform this action.",
          statusCode: 403,
        );
      case 404:
        return NotFoundException(
          msg: errorMessage ?? "Requested resource could not be found.",
          statusCode: 404,
        );
      case 409:
        return ConflictException(
          msg: errorMessage ?? "Conflict occurred. Data might already exist.",
          statusCode: 409,
        );
      case 422:
        return InvalidInputException(
          msg: errorMessage ?? "Validation failed. Please verify the submitted data.",
          statusCode: 422,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          msg: errorMessage ?? "Server error occurred. Please try again later.",
          statusCode: statusCode,
        );
      default:
        return FetchDataException(
          msg: errorMessage ?? "Communication error ($statusCode).",
          statusCode: statusCode,
        );
    }
  }

  /// Helper to extract human-readable error messages from diverse response formats
  static String? _extractMessage(dynamic data) {
    if (data == null) return null;

    if (data is String) {
      return data.isNotEmpty ? data : null;
    }

    if (data is Map) {
      // Common FastAPI error: {"detail": "..."}
      if (data.containsKey('detail')) {
        final detail = data['detail'];
        if (detail is String) return detail;
        if (detail is List && detail.isNotEmpty) {
          final first = detail.first;
          if (first is Map && first.containsKey('msg')) {
            return first['msg'].toString();
          }
          return detail.join(', ');
        }
      }

      if (data.containsKey('message') && data['message'] != null) {
        return data['message'].toString();
      }
      if (data.containsKey('error') && data['error'] != null) {
        return data['error'].toString();
      }
      if (data.containsKey('msg') && data['msg'] != null) {
        return data['msg'].toString();
      }
    }

    return null;
  }
}

class NoInternetException extends AppExceptionHandler {
  NoInternetException({required String msg})
      : super(exTitle: "No Internet", exMsg: msg);
}

class TimeoutException extends AppExceptionHandler {
  TimeoutException({required String msg})
      : super(exTitle: "Request Timeout", exMsg: msg);
}

class ServerException extends AppExceptionHandler {
  ServerException({required String msg, int? statusCode})
      : super(exTitle: "Server Error", exMsg: msg, statusCode: statusCode);
}

class BadRequestException extends AppExceptionHandler {
  BadRequestException({required String msg, int? statusCode})
      : super(exTitle: "Bad Request", exMsg: msg, statusCode: statusCode);
}

class UnauthorizedException extends AppExceptionHandler {
  UnauthorizedException({required String msg, int? statusCode})
      : super(exTitle: "Unauthorized", exMsg: msg, statusCode: statusCode);
}

class ForbiddenException extends AppExceptionHandler {
  ForbiddenException({required String msg, int? statusCode})
      : super(exTitle: "Access Denied", exMsg: msg, statusCode: statusCode);
}

class NotFoundException extends AppExceptionHandler {
  NotFoundException({required String msg, int? statusCode})
      : super(exTitle: "Not Found", exMsg: msg, statusCode: statusCode);
}

class ConflictException extends AppExceptionHandler {
  ConflictException({required String msg, int? statusCode})
      : super(exTitle: "Conflict", exMsg: msg, statusCode: statusCode);
}

class InvalidInputException extends AppExceptionHandler {
  InvalidInputException({required String msg, int? statusCode})
      : super(exTitle: "Invalid Input", exMsg: msg, statusCode: statusCode);
}

class FetchDataException extends AppExceptionHandler {
  FetchDataException({required String msg, int? statusCode})
      : super(
          exTitle: "Error During Communication",
          exMsg: msg,
          statusCode: statusCode,
        );
}