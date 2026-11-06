import 'package:equatable/equatable.dart';
import 'user_profile_model.dart';

class UserProfileUpdateResponseModel extends Equatable {
  final bool? success;
  final String? message;
  final Data? data;

  const UserProfileUpdateResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory UserProfileUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return UserProfileUpdateResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] is Map<String, dynamic>
          ? Data.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data!.toJson();
    }
    return map;
  }

  UserProfileUpdateResponseModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return UserProfileUpdateResponseModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  UserProfileModel toUserProfileModel() {
    return UserProfileModel(
      success: success,
      message: message,
      data: data,
    );
  }

  // ── Convenience getters ──────────────────────────────────────────────────
  String get fullName => data?.fullName ?? '';
  String get username => data?.username ?? fullName;
  String get phoneNumber => data?.phoneNumber ?? '';
  String get email => data?.email ?? '';
  int get civilScore => data?.civilScore ?? 0;
  int get maxCivilScore => data?.maxCivilScore ?? 1000;
  String get civilRating => data?.civilRating ?? 'N/A';
  double get scorePercent => data?.scorePercent ?? 0.0;
  int get vehiclesCount => data?.vehiclesCount ?? 0;
  String get vehiclesCountText =>
      data?.vehiclesCountText ?? '$vehiclesCount Vehicles';
  String get paymentMethodsText => data?.paymentMethodsText ?? 'Add Method';
  String get userId => data?.userId ?? '';

  @override
  List<Object?> get props => [success, message, data];
}

