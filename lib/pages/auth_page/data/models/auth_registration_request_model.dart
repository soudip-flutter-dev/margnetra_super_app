class RegistrationRequestModel {
  String? fullName;
  String? phone;
  String? email;
  String? password;
  String? confirmPassword;

  RegistrationRequestModel({
    String? fullName,
    String? name,
    this.phone,
    this.email,
    this.password,
    this.confirmPassword,
  }) : fullName = fullName ?? name;

  factory RegistrationRequestModel.fromJson(Map<String, dynamic> json) {
    return RegistrationRequestModel(
      fullName: json['full_name'] ?? json['fullName'],
      phone: json['phone'],
      email: json['email'],
      password: json['password'],
      confirmPassword: json['confirm_password'] ?? json['confirmPassword'],
    );
  }

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "email": email,
    "password": password,
    "phone": phone,
    "full_name": fullName,
    "confirm_password": confirmPassword,
  };
}
