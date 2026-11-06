import 'package:equatable/equatable.dart';

class UserProfileUpdateRequestModel extends Equatable {
  final String? username;
  final String? fullName;
  final String? email;
  final String? effectiveName;
  final String? cleanEmail;

  const UserProfileUpdateRequestModel({
    this.username,
    this.fullName,
    this.email,
    this.effectiveName,
    this.cleanEmail,
  });

  factory UserProfileUpdateRequestModel.fromJson(Map<String, dynamic> json) {
    return UserProfileUpdateRequestModel(
      username: json['username']?.toString(),
      fullName: json['fullName']?.toString(),
      email: json['email']?.toString(),
      effectiveName: json['effectiveName']?.toString(),
      cleanEmail: json['cleanEmail']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (username != null && username!.isNotEmpty) {
      map['username'] = username;
    }
    if (fullName != null && fullName!.isNotEmpty) {
      map['fullName'] = fullName;
    }
    if (email != null && email!.isNotEmpty) {
      map['email'] = email;
    }
    if (effectiveName != null && effectiveName!.isNotEmpty) {
      map['effectiveName'] = effectiveName;
    } else if ((fullName != null && fullName!.isNotEmpty) ||
        (username != null && username!.isNotEmpty)) {
      map['effectiveName'] = fullName ?? username;
    }
    if (cleanEmail != null && cleanEmail!.isNotEmpty) {
      map['cleanEmail'] = cleanEmail;
    } else if (email != null && email!.isNotEmpty) {
      map['cleanEmail'] = email!.trim().toLowerCase();
    }
    return map;
  }

  UserProfileUpdateRequestModel copyWith({
    String? username,
    String? fullName,
    String? email,
    String? effectiveName,
    String? cleanEmail,
  }) {
    return UserProfileUpdateRequestModel(
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      effectiveName: effectiveName ?? this.effectiveName,
      cleanEmail: cleanEmail ?? this.cleanEmail,
    );
  }

  @override
  List<Object?> get props => [
        username,
        fullName,
        email,
        effectiveName,
        cleanEmail,
      ];
}

