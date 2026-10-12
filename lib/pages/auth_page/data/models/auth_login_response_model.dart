class LoginResponseModel {
  String? accessToken;
  String? refreshToken;
  String? tokenType;
  int? expiresIn;

  LoginResponseModel({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  String get token => accessToken ?? '';

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['access_token'] ?? json['accessToken'] ?? json['token'],
      refreshToken: json['refresh_token'] ?? json['refreshToken'],
      tokenType: json['token_type'] ?? json['tokenType'],
      expiresIn: json['expires_in'] ?? json['expiresIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }
}
