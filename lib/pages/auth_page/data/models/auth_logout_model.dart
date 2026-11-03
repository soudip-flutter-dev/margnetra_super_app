class LogoutRequestModel {
  final String refreshToken;

  LogoutRequestModel({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }

  factory LogoutRequestModel.fromJson(Map<String, dynamic> json) {
    return LogoutRequestModel(
      refreshToken: json['refreshToken'] ?? json['refresh_token'] ?? '',
    );
  }
}

class LogoutResponseModel {
  final bool? success;
  final String? message;

  LogoutResponseModel({
    this.success,
    this.message,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) {
    return LogoutResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
