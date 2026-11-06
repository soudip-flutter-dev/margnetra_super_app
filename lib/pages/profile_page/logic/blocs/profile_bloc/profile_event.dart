import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/user_profile_update_request_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfileEvent extends ProfileEvent {
  final bool forceRefresh;
  const LoadProfileEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class UpdateProfileEvent extends ProfileEvent {
  final String? fullName;
  final String? email;
  final String? username;
  final String? effectiveName;
  final String? cleanEmail;
  final UserProfileUpdateRequestModel? request;

  const UpdateProfileEvent({
    this.fullName,
    this.email,
    this.username,
    this.effectiveName,
    this.cleanEmail,
    this.request,
  });

  @override
  List<Object?> get props => [
        fullName,
        email,
        username,
        effectiveName,
        cleanEmail,
        request,
      ];
}

class UploadAvatarEvent extends ProfileEvent {
  final String filePath;

  const UploadAvatarEvent(this.filePath);

  @override
  List<Object?> get props => [filePath];
}

class AddPaymentMethodEvent extends ProfileEvent {
  final String type;
  final String identifier;

  const AddPaymentMethodEvent({required this.type, required this.identifier});

  @override
  List<Object?> get props => [type, identifier];
}
