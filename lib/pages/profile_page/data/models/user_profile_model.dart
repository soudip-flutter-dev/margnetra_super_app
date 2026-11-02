import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  final int id;
  final String fullName;
  final String phone;
  final String? email;
  final String? avatarUrl;
  final double civilScore;
  final int drivingStreakDays;
  final double mgcBalance;
  final bool isActive;
  final bool isVerified;
  final DateTime? createdAt;

  const UserProfileModel({
    required this.id,
    required this.fullName,
    required this.phone,
    this.email,
    this.avatarUrl,
    this.civilScore = 750.0,
    this.drivingStreakDays = 0,
    this.mgcBalance = 0.0,
    this.isActive = true,
    this.isVerified = false,
    this.createdAt,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fullName: json['full_name'] ?? json['name'] ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString(),
      avatarUrl: json['avatar_url']?.toString(),
      civilScore: (json['civil_score'] is num)
          ? (json['civil_score'] as num).toDouble()
          : double.tryParse(json['civil_score']?.toString() ?? '750.0') ?? 750.0,
      drivingStreakDays: (json['driving_streak_days'] is int)
          ? json['driving_streak_days'] as int
          : int.tryParse(json['driving_streak_days']?.toString() ?? '0') ?? 0,
      mgcBalance: (json['mgc_balance'] is num)
          ? (json['mgc_balance'] as num).toDouble()
          : double.tryParse(json['mgc_balance']?.toString() ?? '0.0') ?? 0.0,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'avatar_url': avatarUrl,
      'civil_score': civilScore,
      'driving_streak_days': drivingStreakDays,
      'mgc_balance': mgcBalance,
      'is_active': isActive,
      'is_verified': isVerified,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  UserProfileModel copyWith({
    int? id,
    String? fullName,
    String? phone,
    String? email,
    String? avatarUrl,
    double? civilScore,
    int? drivingStreakDays,
    double? mgcBalance,
    bool? isActive,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      civilScore: civilScore ?? this.civilScore,
      drivingStreakDays: drivingStreakDays ?? this.drivingStreakDays,
      mgcBalance: mgcBalance ?? this.mgcBalance,
      isActive: isActive ?? this.isActive,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        phone,
        email,
        avatarUrl,
        civilScore,
        drivingStreakDays,
        mgcBalance,
        isActive,
        isVerified,
        createdAt,
      ];
}
