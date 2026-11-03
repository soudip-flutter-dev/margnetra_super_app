class LoginResponseModel {
  bool? success;
  String? message;
  Data? data;

  LoginResponseModel({this.success, this.message, this.data});

 factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
     success: json['success'],
     message: json['message'],
     data: json['data'] != null ? Data.fromJson(json['data']) : null,
   );
   }

  Map<String, dynamic> toJson() =>{
"success": success,
"message": message,
"data": data?.toJson(),
  };
}

class Data {
  String? accessToken;
  String? refreshToken;
  String? tokenType;
  int? expiresIn;
  User? user;

  Data(
      {this.accessToken,
      this.refreshToken,
      this.tokenType,
      this.expiresIn,
      this.user});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      accessToken: json['accessToken'] ?? json['access_token'],
      refreshToken: json['refreshToken'] ?? json['refresh_token'],
      tokenType: json['tokenType'] ?? json['token_type'],
      expiresIn: json['expiresIn'] ?? json['expires_in'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
"accessToken": accessToken,
"refreshToken": refreshToken,
"tokenType": tokenType,
"expiresIn": expiresIn,
"user": user?.toJson(),
  };
}

class User {
  String? id;
  String? fullName;
  String? email;

  User({this.id, this.fullName, this.email});

 factory User.fromJson(Map<String, dynamic> json) {
   return User(
     id: json['id'],
     fullName: json['fullName'],
     email: json['email'],
   );
  }

  Map<String, dynamic> toJson() =>{
"id": id,
"fullName": fullName,
"email": email,
  };
}
