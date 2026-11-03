import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/auth_registration_response_model.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/models.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/user_model.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action
class AuthInitial extends AuthState {}

/// State while an async auth operation is ongoing
class AuthLoading extends AuthState {}

/// State when user is successfully authenticated
class AuthAuthenticated extends AuthState {
  final String ?token;
  final RegistrationResponseModel? registrationResponse;
  final UserModel? user;

  const AuthAuthenticated({
     this.token,
    this.registrationResponse,
    this.user,
  });

  @override
  List<Object?> get props => [token, user];
}

/// State when user is not logged in / logged out
class AuthUnauthenticated extends AuthState {
  final String? message;

  const AuthUnauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

/// State when forgot password request succeeds
class ForgotPasswordSuccess extends AuthState {
  final ForgotPasswordResponseModel response;

  const ForgotPasswordSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

/// State when reset password request succeeds
class ResetPasswordSuccess extends AuthState {
  final ResetPasswordResponseModel response;

  const ResetPasswordSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

/// State when an authentication operation fails
class AuthError extends AuthState {
  final String title;
  final String message;
  final int? statusCode;

  const AuthError({
    required this.message,
    this.title = 'Authentication Error',
    this.statusCode,
  });

  @override
  List<Object?> get props => [title, message, statusCode];
}
