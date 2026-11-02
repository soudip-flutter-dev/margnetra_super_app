import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_exception_handler/app_exception_handler.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/profile_models.dart';
import 'package:margnetra_super_app/pages/profile_page/data/repositories/user_repository.dart';
import 'profile_event.dart';
import 'profile_state.dart';

export 'profile_event.dart';
export 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final IUserRepository _userRepository;

  ProfileBloc({required IUserRepository userRepository})
      : _userRepository = userRepository,
        super(const ProfileInitial()) {
    on<LoadProfileEvent>(_onLoadProfile);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<UploadAvatarEvent>(_onUploadAvatar);
    on<AddPaymentMethodEvent>(_onAddPaymentMethod);
  }

  Future<void> _onLoadProfile(
    LoadProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final cached = _userRepository.getCachedProfile();
    if (cached != null && !event.forceRefresh) {
      emit(ProfileLoaded(profile: cached));
    } else {
      emit(ProfileLoading(cachedProfile: cached));
    }

    try {
      final profile = await _userRepository.getUserProfile();

      CivilScoreModel? civilScore;
      try {
        civilScore = await _userRepository.getCivilScore();
      } catch (_) {
        civilScore = null;
      }

      List<PaymentMethodModel> paymentMethods = [];
      try {
        paymentMethods = await _userRepository.getPaymentMethods();
      } catch (_) {
        paymentMethods = [];
      }

      emit(ProfileLoaded(
        profile: profile,
        civilScore: civilScore,
        paymentMethods: paymentMethods,
      ));
    } catch (e) {
      final message = e is AppExceptionHandler ? e.exMsg : e.toString();
      emit(ProfileError(message: message, cachedProfile: cached));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(currentState.copyWith(isUpdating: true));
    }

    try {
      final updated = await _userRepository.updateUserProfile(
        fullName: event.fullName,
        email: event.email,
      );

      if (currentState is ProfileLoaded) {
        emit(currentState.copyWith(profile: updated, isUpdating: false));
      } else {
        emit(ProfileLoaded(profile: updated));
      }
    } catch (e) {
      final message = e is AppExceptionHandler ? e.exMsg : e.toString();
      if (currentState is ProfileLoaded) {
        emit(currentState.copyWith(isUpdating: false));
      }
      emit(ProfileError(message: message));
    }
  }

  Future<void> _onUploadAvatar(
    UploadAvatarEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    if (currentState is ProfileLoaded) {
      emit(currentState.copyWith(isUpdating: true));
    }

    try {
      final updated = await _userRepository.uploadAvatar(event.filePath);

      if (currentState is ProfileLoaded) {
        emit(currentState.copyWith(profile: updated, isUpdating: false));
      } else {
        emit(ProfileLoaded(profile: updated));
      }
    } catch (e) {
      final message = e is AppExceptionHandler ? e.exMsg : e.toString();
      if (currentState is ProfileLoaded) {
        emit(currentState.copyWith(isUpdating: false));
      }
      emit(ProfileError(message: message));
    }
  }

  Future<void> _onAddPaymentMethod(
    AddPaymentMethodEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final currentState = state;
    try {
      final newMethod = await _userRepository.addPaymentMethod(
        type: event.type,
        identifier: event.identifier,
      );

      if (currentState is ProfileLoaded) {
        final updatedList = List.of(currentState.paymentMethods)..add(newMethod);
        emit(currentState.copyWith(paymentMethods: updatedList));
      }
    } catch (e) {
      final message = e is AppExceptionHandler ? e.exMsg : e.toString();
      emit(ProfileError(message: message));
    }
  }
}
