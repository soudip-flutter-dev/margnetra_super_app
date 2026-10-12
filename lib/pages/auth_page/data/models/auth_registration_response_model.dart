import 'user_model.dart';

class RegistrationResponseModel {
  int? id;
  String? fullName;
  String? phone;
  String? email;
  String? avatarUrl;
  bool? isActive;
  bool? isVerified;
  int? civilScore;
  int? drivingStreakDays;
  String? createdAt;
  String? accessToken;
  String? refreshToken;

  RegistrationResponseModel({
    this.id,
    this.fullName,
    this.phone,
    this.email,
    this.avatarUrl,
    this.isActive,
    this.isVerified,
    this.civilScore,
    this.drivingStreakDays,
    this.createdAt,
    this.accessToken,
    this.refreshToken,
  });

  String get token => accessToken ?? '';

  UserModel toUserModel() {
    return UserModel(
      id: id?.toString() ?? '',
      name: fullName ?? '',
      email: email ?? '',
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }

  factory RegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return RegistrationResponseModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? ''),
      fullName: json['full_name'] ?? json['fullName'] ?? json['name'],
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      avatarUrl: json['avatar_url'] ?? json['avatarUrl'] ?? json['avatar'],
      isActive: json['is_active'] ?? json['isActive'],
      isVerified: json['is_verified'] ?? json['isVerified'],
      civilScore: json['civil_score'] is int
          ? json['civil_score']
          : int.tryParse(json['civil_score']?.toString() ?? ''),
      drivingStreakDays: json['driving_streak_days'] is int
          ? json['driving_streak_days']
          : int.tryParse(json['driving_streak_days']?.toString() ?? ''),
      createdAt: json['created_at'] ?? json['createdAt'],
      accessToken: json['access_token'] ?? json['token'],
      refreshToken: json['refresh_token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'avatar_url': avatarUrl,
      'is_active': isActive,
      'is_verified': isVerified,
      'civil_score': civilScore,
      'driving_streak_days': drivingStreakDays,
      'created_at': createdAt,
      if (accessToken != null) 'access_token': accessToken,
      if (refreshToken != null) 'refresh_token': refreshToken,
    };
  }
}
