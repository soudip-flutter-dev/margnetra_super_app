import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/core/app_services/api_services/data_provider.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/auth_registration_response_model.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/models.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/user_model.dart';
import 'package:margnetra_super_app/pages/auth_page/data/repositories/base_repository.dart';

abstract class IAuthRepository {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<RegistrationResponseModel> register(RegisterRequestModel request);
  Future<ForgotPasswordResponseModel> forgotPassword(ForgotPasswordRequestModel request);
  Future<ResetPasswordResponseModel> resetPassword(ResetPasswordRequestModel request);
  Future<UserModel> getUserProfile();
  Future<LogoutResponseModel?> logout({String? refreshToken});
  Future<RefreshTokanResponse> refreshTokan({String? refreshTokan});
  bool isAuthenticated();
  UserModel? getCachedUser();
}

class AuthRepository extends BaseRepository implements IAuthRepository {
  final DataProvider _dataProvider;
  final SharedPrefService _prefService;

  AuthRepository({
    DataProvider? dataProvider,
    SharedPrefService? prefService,
  })  : _dataProvider = dataProvider ?? DataProvider(),
        _prefService = prefService ?? SharedPrefService.instance;

  @override
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    // The interceptor skips auth header for login automatically.
    final response = await _dataProvider.post(
      ApiUrls.login,
      data: request.toJson(),
    );

    final loginResponse = LoginResponseModel.fromJson(
      response is Map<String, dynamic> ? response : <String, dynamic>{},
    );

    // Persist session into local storage
    if (loginResponse.data?.accessToken?.isNotEmpty == true) {
      await _prefService.saveAuthToken(loginResponse.data!.accessToken!);
      await _prefService.setLoggedIn(true);

      if (loginResponse.data!.refreshToken?.isNotEmpty == true) {
        await _prefService.saveRefreshToken(loginResponse.data!.refreshToken!);
      }
    }

    return loginResponse;
  }

  @override
  Future<RegistrationResponseModel> register(RegisterRequestModel request) async {
    // The interceptor skips auth header for register automatically.
    final response = await _dataProvider.post(
      ApiUrls.register,
      data: request.toJson(),
    );

    final registrationResponse = RegistrationResponseModel.fromJson(
      response is Map<String, dynamic> ? response : <String, dynamic>{},
    );

    // Persist session if registration automatically returns tokens
    // if (registrationResponse.token.isNotEmpty) {
    //   await _prefService.saveAuthToken(registrationResponse.token);
    //   await _prefService.setLoggedIn(true);

    //   if (registrationResponse.refreshToken != null &&
    //       registrationResponse.refreshToken!.isNotEmpty) {
    //     await _prefService.saveRefreshToken(registrationResponse.refreshToken!);
    //   }
    // }

    if (registrationResponse.data?.id != null) {
      await _prefService.saveUserData(registrationResponse.toJson());
      await _prefService.saveUserId(registrationResponse.data!.id.toString());
    }

    return registrationResponse;
  }

  @override
  Future<ForgotPasswordResponseModel> forgotPassword(
      ForgotPasswordRequestModel request) async {
    final response = await _dataProvider.post(
      ApiUrls.forgotPassword,
      data: request.toJson(),
    );

    return ForgotPasswordResponseModel.fromJson(
      response is Map<String, dynamic> ? response : <String, dynamic>{},
    );
  }

  @override
  Future<ResetPasswordResponseModel> resetPassword(
      ResetPasswordRequestModel request) async {
    final response = await _dataProvider.post(
      ApiUrls.resetPassword,
      data: request.toJson(),
    );

    return ResetPasswordResponseModel.fromJson(
      response is Map<String, dynamic> ? response : <String, dynamic>{},
    );
  }

  @override
  Future<UserModel> getUserProfile() async {
    // Bearer token is attached automatically by the interceptor.
    final response = await _dataProvider.get(ApiUrls.userProfile);

    final user = UserModel.fromJson(
      response is Map<String, dynamic> ? response : <String, dynamic>{},
    );

    // Update local cache
    await _prefService.saveUserData(user.toJson());
    return user;
  }

  @override
  Future<LogoutResponseModel?> logout({String? refreshToken}) async {
    final token = refreshToken ?? _prefService.getRefreshToken();
    LogoutResponseModel? logoutResponse;
    try {
      if (token != null && token.trim().isNotEmpty) {
        final response = await _dataProvider.post(
          ApiUrls.logout,
          data: LogoutRequestModel(refreshToken: token.trim()).toJson(),
        );
        if (response is Map<String, dynamic>) {
          logoutResponse = LogoutResponseModel.fromJson(response);
        }
      }
      logoutResponse ??= LogoutResponseModel(
        success: true,
        message: 'Logged out successfully',
      );
    } catch (_) {
      // Even if network or backend returns an error (e.g. 400 Bad Request if token was already invalidated),
      // allow sign out to complete locally so the user is never stuck.
      logoutResponse = LogoutResponseModel(
        success: true,
        message: 'Logged out successfully',
      );
    } finally {
      await _prefService.clearAuthSession();
    }
    return logoutResponse;
  }

  /// Calls `POST /api/auth/refresh`.
  ///
  /// - New tokens are automatically persisted inside [DataProvider.refreshTokan].
  /// - Pass [refreshTokan] to supply a specific token; omit it to use the
  ///   value already stored in [SharedPrefService].
  @override
  Future<RefreshTokanResponse> refreshTokan({String? refreshTokan}) async {
    return _dataProvider.refreshTokan(refreshTokan: refreshTokan);
  }

  @override
  bool isAuthenticated() {
    final token = _prefService.getAuthToken();
    return _prefService.isLoggedIn && token != null && token.isNotEmpty;
  }

  @override
  UserModel? getCachedUser() {
    final json = _prefService.getUserData();
    if (json != null) {
      return UserModel.fromJson(json);
    }
    return null;
  }
}
