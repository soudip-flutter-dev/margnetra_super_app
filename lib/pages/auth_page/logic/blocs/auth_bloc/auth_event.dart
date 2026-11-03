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
  final RegisterRequestModel mRegisterRequest;

  const RegisterEvent({required this.mRegisterRequest});

  @override
  List<Object?> get props => [mRegisterRequest];
}

/// Event to perform user logout
class LogoutEvent extends AuthEvent {
  final String? refreshToken;

  const LogoutEvent({this.refreshToken});

  @override
  List<Object?> get props => [refreshToken];
}

/// Event to request password reset instructions via email
class ForgotPasswordEvent extends AuthEvent {
  final ForgotPasswordRequestModel mForgotPasswordRequest;

  const ForgotPasswordEvent({required this.mForgotPasswordRequest});

  @override
  List<Object?> get props => [mForgotPasswordRequest];
}

/// Event to reset user password with token
class ResetPasswordEvent extends AuthEvent {
  final ResetPasswordRequestModel mResetPasswordRequest;

  const ResetPasswordEvent({required this.mResetPasswordRequest});

  @override
  List<Object?> get props => [mResetPasswordRequest];
}

