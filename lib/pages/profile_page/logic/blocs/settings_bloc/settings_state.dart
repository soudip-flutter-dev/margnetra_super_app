import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/app_settings_model.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final AppSettingsModel settings;
  final bool isSyncing;
  final String? syncError;

  const SettingsLoaded({
    required this.settings,
    this.isSyncing = false,
    this.syncError,
  });

  SettingsLoaded copyWith({
    AppSettingsModel? settings,
    bool? isSyncing,
    String? syncError,
  }) {
    return SettingsLoaded(
      settings: settings ?? this.settings,
      isSyncing: isSyncing ?? this.isSyncing,
      syncError: syncError,
    );
  }

  @override
  List<Object?> get props => [settings, isSyncing, syncError];
}

class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}
