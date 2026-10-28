import 'package:equatable/equatable.dart';

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

  const UpdateProfileEvent({this.fullName, this.email});

  @override
  List<Object?> get props => [fullName, email];
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
