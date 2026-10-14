import 'package:equatable/equatable.dart';
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
  final String token;
  final UserModel? user;

  const AuthAuthenticated({
    required this.token,
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
