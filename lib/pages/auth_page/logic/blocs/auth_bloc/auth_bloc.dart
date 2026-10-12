import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_exception_handler/app_exception_handler.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/models.dart';
import 'package:margnetra_super_app/pages/auth_page/data/repositories/auth_repository.dart';
import 'package:margnetra_super_app/pages/auth_page/logic/blocs/auth_bloc/auth_event.dart';
import 'package:margnetra_super_app/pages/auth_page/logic/blocs/auth_bloc/auth_state.dart';

export 'auth_event.dart';
export 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final IAuthRepository _authRepository;

  AuthBloc({IAuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(AuthInitial()) {
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final isAuth = _authRepository.isAuthenticated();
      if (isAuth) {
        final cachedUser = _authRepository.getCachedUser();
        emit(AuthAuthenticated(
          token: '',
          user: cachedUser,
        ));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.login(event.mLoginRequest);
      UserModel? user;
      try {
        user = await _authRepository.getUserProfile();
      } catch (_) {
        user = _authRepository.getCachedUser();
      }
      emit(AuthAuthenticated(
        token: response.token,
        user: user,
      ));
    } on AppExceptionHandler catch (e) {
      emit(AuthError(
        title: e.exTitle,
        message: e.exMsg,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      emit(AuthError(
        title: 'Error',
        message: e.toString(),
      ));
    }
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final response = await _authRepository.register(event.mRegisterRequest);
      emit(AuthAuthenticated(
        token: response.token,
        user: response.toUserModel(),
      ));
    } on AppExceptionHandler catch (e) {
      emit(AuthError(
        title: e.exTitle,
        message: e.exMsg,
        statusCode: e.statusCode,
      ));
    } catch (e) {
      emit(AuthError(
        title: 'Error',
        message: e.toString(),
      ));
    }
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _authRepository.logout();
    } finally {
      emit(AuthUnauthenticated());
    }
  }
}
