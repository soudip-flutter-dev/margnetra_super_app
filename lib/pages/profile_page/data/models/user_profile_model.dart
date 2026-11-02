import 'package:equatable/equatable.dart';

class UserProfileModel extends Equatable {
  bool? success;
  String? message;
  Data? data;

  UserProfileModel({this.success, this.message, this.data});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['success'] = success;
    map['message'] = message;
    if (data != null) map['data'] = data!.toJson();
    return map;
  }

  // ── Convenience getters so widgets don't need to drill into .data ──

  String get fullName => data?.fullName ?? '';
  String get phoneNumber => data?.phoneNumber ?? '';
  String get email => data?.email ?? '';
  int get civilScore => data?.civilScore ?? 0;
  int get maxCivilScore => data?.maxCivilScore ?? 1000;
  String get civilRating => data?.civilRating ?? 'N/A';
  double get scorePercent => data?.scorePercent ?? 0.0;
  int get vehiclesCount => data?.vehiclesCount ?? 0;
  String get vehiclesCountText => data?.vehiclesCountText ?? '0 Registered';
  String get paymentMethodsText => data?.paymentMethodsText ?? 'Add Method';
  String get userId => data?.userId ?? '';

  @override
  List<Object?> get props => [success, message, data];
}

class Data extends Equatable {
  String? userId;
  String? fullName;
  String? phoneNumber;
  String? email;
  int? civilScore;
  int? maxCivilScore;
  String? civilRating;
  double? scorePercent;
  int? vehiclesCount;
  String? vehiclesCountText;
  String? paymentMethodsText;

  Data({
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
  });

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId']?.toString();
    fullName = json['fullName']?.toString();
    phoneNumber = json['phoneNumber']?.toString();
    email = json['email']?.toString();
    civilScore = json['civilScore'] is int
        ? json['civilScore'] as int
        : int.tryParse(json['civilScore']?.toString() ?? '0');
    maxCivilScore = json['maxCivilScore'] is int
        ? json['maxCivilScore'] as int
        : int.tryParse(json['maxCivilScore']?.toString() ?? '1000');
    civilRating = json['civilRating']?.toString();
    scorePercent = json['scorePercent'] is num
        ? (json['scorePercent'] as num).toDouble()
        : double.tryParse(json['scorePercent']?.toString() ?? '0');
    vehiclesCount = json['vehiclesCount'] is int
        ? json['vehiclesCount'] as int
        : int.tryParse(json['vehiclesCount']?.toString() ?? '0');
    vehiclesCountText = json['vehiclesCountText']?.toString();
    paymentMethodsText = json['paymentMethodsText']?.toString();
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
      };

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
      ];
}
