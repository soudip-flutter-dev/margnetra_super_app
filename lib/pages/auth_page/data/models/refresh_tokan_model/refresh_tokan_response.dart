class RefreshTokanResponse {
  bool? success;
  String? message;
  Data? data;

  RefreshTokanResponse({this.success, this.message, this.data});

  RefreshTokanResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }
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

  Data.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    tokenType = json['tokenType'];
    expiresIn = json['expiresIn'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['accessToken'] = accessToken;
    map['refreshToken'] = refreshToken;
    map['tokenType'] = tokenType;
    map['expiresIn'] = expiresIn;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
  }
}

class User {
  String? id;
  String? fullName;
  String? email;

  User({this.id, this.fullName, this.email});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['id'] = id;
    map['fullName'] = fullName;
    map['email'] = email;
    return map;
  }
}
