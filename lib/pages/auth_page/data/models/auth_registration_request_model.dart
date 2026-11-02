class RegisterRequestModel {
  String? fullName;
  String? email;
  String? phoneNumber;
  String? password;
  String? confirmPassword;

  RegisterRequestModel(
      {this.fullName,
      this.email,
      this.phoneNumber,
      this.password,
      this.confirmPassword});

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    return RegisterRequestModel(
      fullName: json['fullName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      password: json['password'],
      confirmPassword: json['confirmPassword'],
    );
  }

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "email": email,
    "phoneNumber": phoneNumber,
    "password": password,
    "confirmPassword": confirmPassword,
  };
}
