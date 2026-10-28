import 'package:equatable/equatable.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingsEvent {
  const LoadSettingsEvent();
}

class UpdateSettingToggleEvent extends SettingsEvent {
  final bool? notificationsEnabled;
  final bool? locationSharing;
  final bool? darkMode;
  final String? language;
  final bool? hudOverlay;

  const UpdateSettingToggleEvent({
    this.notificationsEnabled,
    this.locationSharing,
    this.darkMode,
    this.language,
    this.hudOverlay,
  });

  @override
  List<Object?> get props => [
        notificationsEnabled,
        locationSharing,
        darkMode,
        language,
        hudOverlay,
      ];
}
