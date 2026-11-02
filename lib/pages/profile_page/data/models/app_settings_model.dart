import 'package:equatable/equatable.dart';

class AppSettingsModel extends Equatable {
  final bool notificationsEnabled;
  final bool locationSharing;
  final bool darkMode;
  final String language;
  final bool hudOverlay;
  final DateTime? updatedAt;

  const AppSettingsModel({
    this.notificationsEnabled = true,
    this.locationSharing = true,
    this.darkMode = true,
    this.language = 'en',
    this.hudOverlay = true,
    this.updatedAt,
  });

  factory AppSettingsModel.fromJson(Map<String, dynamic> json) {
    return AppSettingsModel(
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      locationSharing: json['location_sharing'] as bool? ?? true,
      darkMode: json['dark_mode'] as bool? ?? true,
      language: json['language']?.toString() ?? 'en',
      hudOverlay: json['hud_overlay'] as bool? ?? true,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notifications_enabled': notificationsEnabled,
      'location_sharing': locationSharing,
      'dark_mode': darkMode,
      'language': language,
      'hud_overlay': hudOverlay,
      if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
    };
  }

  AppSettingsModel copyWith({
    bool? notificationsEnabled,
    bool? locationSharing,
    bool? darkMode,
    String? language,
    bool? hudOverlay,
    DateTime? updatedAt,
  }) {
    return AppSettingsModel(
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      locationSharing: locationSharing ?? this.locationSharing,
      darkMode: darkMode ?? this.darkMode,
      language: language ?? this.language,
      hudOverlay: hudOverlay ?? this.hudOverlay,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        notificationsEnabled,
        locationSharing,
        darkMode,
        language,
        hudOverlay,
        updatedAt,
      ];
}
