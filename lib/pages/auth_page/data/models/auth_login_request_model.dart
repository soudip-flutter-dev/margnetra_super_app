class LoginRequestModel {
  String? phone;
  String? email;
  String? username;
  String? password;

  LoginRequestModel({this.phone, this.email, this.username, this.password});

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      phone: json['phone'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
      "email": email,
      "username": username,
      "password": password,
    };
  }
}
