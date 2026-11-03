class ResetPasswordRequestModel {
  final String token;
  final String newPassword;
  final String confirmPassword;

  ResetPasswordRequestModel({
    required this.token,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory ResetPasswordRequestModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordRequestModel(
      token: json['token']?.toString() ?? '',
      newPassword: json['newPassword']?.toString() ?? '',
      confirmPassword: json['confirmPassword']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'newPassword': newPassword,
      'confirmPassword': confirmPassword,
    };
  }
}

