import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  final bool? success;
  final String? message;
  final Data? data;

  const UserProfileModel({this.success, this.message, this.data});

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
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
    if (data != null) map['data'] = data!.toJson();
    return map;
  }

  UserProfileModel copyWith({
    bool? success,
    String? message,
    Data? data,
  }) {
    return UserProfileModel(
      success: success ?? this.success,
      message: message ?? this.message,
      data: data ?? this.data,
    );
  }

  // ── Convenience getters so widgets don't need to drill into .data ──

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

class Data extends Equatable {
  final String? userId;
  final String? fullName;
  final String? phoneNumber;
  final String? email;
  final int? civilScore;
  final int? maxCivilScore;
  final String? civilRating;
  final double? scorePercent;
  final int? vehiclesCount;
  final String? vehiclesCountText;
  final String? paymentMethodsText;
  final String? username;

  const Data({
    this.userId,
    this.fullName,
    this.phoneNumber,
    this.email,
    this.civilScore,
    this.maxCivilScore,
    this.civilRating,
    this.scorePercent,
    this.vehiclesCount,
    this.vehiclesCountText,
    this.paymentMethodsText,
    this.username,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: (json['userId'] ?? json['id'] ?? json['_id'])?.toString(),
      fullName: (json['fullName'] ?? json['name'])?.toString(),
      phoneNumber: (json['phoneNumber'] ?? json['phone'])?.toString(),
      email: json['email']?.toString(),
      civilScore: json['civilScore'] is int
          ? json['civilScore'] as int
          : int.tryParse(json['civilScore']?.toString() ?? '0'),
      maxCivilScore: json['maxCivilScore'] is int
          ? json['maxCivilScore'] as int
          : int.tryParse(json['maxCivilScore']?.toString() ?? '1000'),
      civilRating: json['civilRating']?.toString(),
      scorePercent: json['scorePercent'] is num
          ? (json['scorePercent'] as num).toDouble()
          : double.tryParse(json['scorePercent']?.toString() ?? '0'),
      vehiclesCount: json['vehiclesCount'] is int
          ? json['vehiclesCount'] as int
          : int.tryParse(json['vehiclesCount']?.toString() ?? '0'),
      vehiclesCountText: json['vehiclesCountText']?.toString(),
      paymentMethodsText: json['paymentMethodsText']?.toString(),
      username: (json['username'] ?? json['fullName'] ?? json['name'])?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'email': email,
        'civilScore': civilScore,
        'maxCivilScore': maxCivilScore,
        'civilRating': civilRating,
        'scorePercent': scorePercent,
        'vehiclesCount': vehiclesCount,
        'vehiclesCountText': vehiclesCountText,
        'paymentMethodsText': paymentMethodsText,
        'username': username,
      };

  Data copyWith({
    String? userId,
    String? fullName,
    String? phoneNumber,
    String? email,
    int? civilScore,
    int? maxCivilScore,
    String? civilRating,
    double? scorePercent,
    int? vehiclesCount,
    String? vehiclesCountText,
    String? paymentMethodsText,
    String? username,
  }) {
    return Data(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      civilScore: civilScore ?? this.civilScore,
      maxCivilScore: maxCivilScore ?? this.maxCivilScore,
      civilRating: civilRating ?? this.civilRating,
      scorePercent: scorePercent ?? this.scorePercent,
      vehiclesCount: vehiclesCount ?? this.vehiclesCount,
      vehiclesCountText: vehiclesCountText ?? this.vehiclesCountText,
      paymentMethodsText: paymentMethodsText ?? this.paymentMethodsText,
      username: username ?? this.username,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        fullName,
        phoneNumber,
        email,
        civilScore,
        maxCivilScore,
        civilRating,
        scorePercent,
        vehiclesCount,
        vehiclesCountText,
        paymentMethodsText,
        username,
      ];
}
