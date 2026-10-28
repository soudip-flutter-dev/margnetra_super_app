import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_exception_handler/app_exception_handler.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/app_settings_model.dart';
import 'package:margnetra_super_app/pages/profile_page/data/repositories/user_repository.dart';
import 'settings_event.dart';
import 'settings_state.dart';

export 'settings_event.dart';
export 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final IUserRepository _userRepository;

  SettingsBloc({required IUserRepository userRepository})
      : _userRepository = userRepository,
        super(const SettingsInitial()) {
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdateSettingToggleEvent>(_onUpdateSettingToggle);
  }

  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final cached = _userRepository.getCachedSettings();
    if (cached != null) {
      emit(SettingsLoaded(settings: cached));
    } else {
      emit(const SettingsLoading());
    }

    try {
      final settings = await _userRepository.getAppSettings();
      emit(SettingsLoaded(settings: settings));
    } catch (e) {
      final message = e is AppExceptionHandler ? e.exMsg : e.toString();
      if (cached != null) {
        emit(SettingsLoaded(settings: cached, syncError: message));
      } else {
        emit(SettingsError(message));
      }
    }
  }

  Future<void> _onUpdateSettingToggle(
    UpdateSettingToggleEvent event,
    Emitter<SettingsState> emit,
  ) async {
    final currentState = state;
    final currentSettings = currentState is SettingsLoaded
        ? currentState.settings
        : const AppSettingsModel();

    // Optimistic update
    final optimisticSettings = currentSettings.copyWith(
      notificationsEnabled: event.notificationsEnabled,
      locationSharing: event.locationSharing,
      darkMode: event.darkMode,
      language: event.language,
      hudOverlay: event.hudOverlay,
    );

    emit(SettingsLoaded(settings: optimisticSettings, isSyncing: true));

    try {
      final synced = await _userRepository.updateAppSettings(optimisticSettings);
      emit(SettingsLoaded(settings: synced, isSyncing: false));
    } catch (e) {
      final message = e is AppExceptionHandler ? e.exMsg : e.toString();
      // Revert to prior settings with sync error
      emit(SettingsLoaded(
        settings: currentSettings,
        isSyncing: false,
        syncError: message,
      ));
    }
  }
}
