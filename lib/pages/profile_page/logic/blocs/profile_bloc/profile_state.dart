import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/profile_models.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  final UserProfileModel? cachedProfile;
  const ProfileLoading({this.cachedProfile});

  @override
  List<Object?> get props => [cachedProfile];
}

class ProfileLoaded extends ProfileState {
  final UserProfileModel profile;
  final CivilScoreModel? civilScore;
  final List<PaymentMethodModel> paymentMethods;
  final bool isUpdating;

  const ProfileLoaded({
    required this.profile,
    this.civilScore,
    this.paymentMethods = const [],
    this.isUpdating = false,
  });

  ProfileLoaded copyWith({
    UserProfileModel? profile,
    CivilScoreModel? civilScore,
    List<PaymentMethodModel>? paymentMethods,
    bool? isUpdating,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      civilScore: civilScore ?? this.civilScore,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      isUpdating: isUpdating ?? this.isUpdating,
    );
  }

  @override
  List<Object?> get props => [profile, civilScore, paymentMethods, isUpdating];
}

class ProfileUpdateSuccess extends ProfileState {
  final String message;
  final UserProfileModel profile;

  const ProfileUpdateSuccess({required this.message, required this.profile});

  @override
  List<Object?> get props => [message, profile];
}

class ProfileError extends ProfileState {
  final String message;
  final UserProfileModel? cachedProfile;

  const ProfileError({required this.message, this.cachedProfile});

  @override
  List<Object?> get props => [message, cachedProfile];
}
