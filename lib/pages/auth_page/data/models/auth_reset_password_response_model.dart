class ResetPasswordResponseModel {
  final bool? success;
  final String? message;
  final Map<String, dynamic>? data;

  ResetPasswordResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory ResetPasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? json['data'] as Map<String, dynamic>
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      if (data != null) 'data': data,
    };
  }
}

