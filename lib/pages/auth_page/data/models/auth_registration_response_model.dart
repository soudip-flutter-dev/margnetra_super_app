class RegistrationResponseModel {
  bool? success;
  String? message;
  Data? data;

  RegistrationResponseModel({this.success, this.message, this.data});

 factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return RegistrationResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? id;
  String? fullName;
  String? email;
  String? phoneNumber;
  String? createdAt;

  Data({this.id, this.fullName, this.email, this.phoneNumber, this.createdAt});

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      id: json['id'] as String?,
      fullName: json['fullName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: json['createdAt'] as String?,);
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullName": fullName,
    "email": email,
    "phoneNumber": phoneNumber,
    "createdAt": createdAt,
  };
}
