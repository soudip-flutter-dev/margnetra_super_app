import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/models.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Event to check existing session on app startup
class CheckAuthStatusEvent extends AuthEvent {}

/// Event to perform user login
class LoginEvent extends AuthEvent {
  final LoginRequestModel mLoginRequest;

  const LoginEvent({required this.mLoginRequest});

  @override
  List<Object?> get props => [mLoginRequest];
}

/// Event to perform user registration
class RegisterEvent extends AuthEvent {
  final RegistrationRequestModel mRegisterRequest;

  const RegisterEvent({required this.mRegisterRequest});

  @override
  List<Object?> get props => [mRegisterRequest];
}

/// Event to perform user logout
class LogoutEvent extends AuthEvent {}

