import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/core/app_services/api_services/data_provider.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/auth_page/data/models/models.dart';
import 'package:margnetra_super_app/pages/auth_page/data/repositories/base_repository.dart';

abstract class IAuthRepository {
  Future<LoginResponseModel> login(LoginRequestModel request);
  Future<RegistrationResponseModel> register(RegistrationRequestModel request);
  Future<UserModel> getUserProfile();
  Future<void> logout();
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
    final response = await _dataProvider.post(
      ApiUrls.login,
      data: request.toJson(),
      requiresAuth: false,
    );

    final loginResponse = LoginResponseModel.fromJson(
      response is Map<String, dynamic> ? response : <String, dynamic>{},
    );

    // Persist session into local storage
    if (loginResponse.token.isNotEmpty) {
      await _prefService.saveAuthToken(loginResponse.token);
      await _prefService.setLoggedIn(true);

      if (loginResponse.refreshToken != null &&
          loginResponse.refreshToken!.isNotEmpty) {
        await _prefService.saveRefreshToken(loginResponse.refreshToken!);
      }
    }

    return loginResponse;
  }

  @override
  Future<RegistrationResponseModel> register(
      RegistrationRequestModel request) async {
    final response = await _dataProvider.post(
      ApiUrls.register,
      data: request.toJson(),
      requiresAuth: false,
    );

    final registrationResponse = RegistrationResponseModel.fromJson(
      response is Map<String, dynamic> ? response : <String, dynamic>{},
    );

    // Persist session if registration automatically returns tokens
    if (registrationResponse.token.isNotEmpty) {
      await _prefService.saveAuthToken(registrationResponse.token);
      await _prefService.setLoggedIn(true);

      if (registrationResponse.refreshToken != null &&
          registrationResponse.refreshToken!.isNotEmpty) {
        await _prefService.saveRefreshToken(registrationResponse.refreshToken!);
      }
    }

    if (registrationResponse.id != null) {
      final user = registrationResponse.toUserModel();
      await _prefService.saveUserData(user.toJson());
      await _prefService.saveUserId(user.id);
    }

    return registrationResponse;
  }

  @override
  Future<UserModel> getUserProfile() async {
    final response = await _dataProvider.get(
      ApiUrls.userProfile,
      requiresAuth: true,
    );

    final user = UserModel.fromJson(
      response is Map<String, dynamic> ? response : <String, dynamic>{},
    );

    // Update local cache
    await _prefService.saveUserData(user.toJson());
    return user;
  }

  @override
  Future<void> logout() async {
    try {
      await _dataProvider.post(
        ApiUrls.logout,
        requiresAuth: true,
      );
    } catch (_) {
      // Ignore network errors on logout to allow local sign out
    } finally {
      await _prefService.clearAuthSession();
    }
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
