import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/core/app_services/api_services/data_provider.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/profile_models.dart';

abstract class IUserRepository {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateUserProfile({String? fullName, String? email});
  Future<UserProfileModel> uploadAvatar(String filePath);
  Future<CivilScoreModel> getCivilScore();
  Future<List<VehicleModel>> getVehicles();
  Future<VehicleModel> addVehicle(VehicleCreateRequest request);
  Future<List<PaymentMethodModel>> getPaymentMethods();
  Future<PaymentMethodModel> addPaymentMethod({
    required String type,
    required String identifier,
  });
  Future<AppSettingsModel> getAppSettings();
  Future<AppSettingsModel> updateAppSettings(AppSettingsModel settings);

  UserProfileModel? getCachedProfile();
  List<VehicleModel>? getCachedVehicles();
  AppSettingsModel? getCachedSettings();
}

class UserRepository implements IUserRepository {
  final DataProvider _dataProvider;
  final SharedPrefService _prefService;

  UserRepository({
    DataProvider? dataProvider,
    SharedPrefService? prefService,
  })  : _dataProvider = dataProvider ?? DataProvider(),
        _prefService = prefService ?? SharedPrefService.instance;

  // ── GET /api/auth/me ───────────────────────────────────────────────────────
  @override
  Future<UserProfileModel> getUserProfile() async {
    final response = await _dataProvider.get(ApiUrls.userProfile);

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    final profile = UserProfileModel.fromJson(map);

    // Cache for offline access
    await _prefService.saveUserData(profile.toJson());
    return profile;
  }

  // ── PUT /api/v1/user/settings ──────────────────────────────────────────────
  @override
  Future<UserProfileModel> updateUserProfile({
    String? fullName,
    String? email,
  }) async {
    final data = <String, dynamic>{};
    if (fullName != null) data['fullName'] = fullName;
    if (email != null) data['email'] = email;

    final response = await _dataProvider.put(
      ApiUrls.updateProfile,
      data: data,
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    final profile = UserProfileModel.fromJson(map);

    await _prefService.saveUserData(profile.toJson());
    return profile;
  }

  // ── POST /api/v1/user/avatar (multipart) ──────────────────────────────────
  @override
  Future<UserProfileModel> uploadAvatar(String filePath) async {
    final response = await _dataProvider.uploadFile(
      ApiUrls.userAvatar,
      filePath: filePath,
      fileFieldName: 'file',
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    final profile = UserProfileModel.fromJson(map);

    await _prefService.saveUserData(profile.toJson());
    return profile;
  }

  // ── GET /api/v1/user/civil-score ──────────────────────────────────────────
  @override
  Future<CivilScoreModel> getCivilScore() async {
    final response = await _dataProvider.get(ApiUrls.userCivilScore);

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    return CivilScoreModel.fromJson(map);
  }

  // ── GET /api/v1/user/vehicles ─────────────────────────────────────────────
  @override
  Future<List<VehicleModel>> getVehicles() async {
    final response = await _dataProvider.get(ApiUrls.userVehicles);

    final list = response is List ? response : <dynamic>[];
    final vehicles = list
        .map((e) => VehicleModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    await _prefService.saveCachedVehicles(vehicles.map((v) => v.toJson()).toList());
    return vehicles;
  }

  // ── POST /api/v1/user/vehicles ────────────────────────────────────────────
  @override
  Future<VehicleModel> addVehicle(VehicleCreateRequest request) async {
    final response = await _dataProvider.post(
      ApiUrls.userVehicles,
      data: request.toJson(),
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    return VehicleModel.fromJson(map);
  }

  // ── GET /api/v1/user/payment-methods ──────────────────────────────────────
  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await _dataProvider.get(ApiUrls.userPaymentMethods);

    final list = response is List ? response : <dynamic>[];
    return list
        .map((e) => PaymentMethodModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  // ── POST /api/v1/user/payment-methods ─────────────────────────────────────
  @override
  Future<PaymentMethodModel> addPaymentMethod({
    required String type,
    required String identifier,
  }) async {
    final response = await _dataProvider.post(
      ApiUrls.userPaymentMethods,
      data: {'type': type, 'identifier': identifier},
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    return PaymentMethodModel.fromJson(map);
  }

  // ── GET /api/v1/user/settings ─────────────────────────────────────────────
  @override
  Future<AppSettingsModel> getAppSettings() async {
    final response = await _dataProvider.get(ApiUrls.userSettings);

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    final settings = AppSettingsModel.fromJson(map);

    await _prefService.saveAppSettings(settings.toJson());
    return settings;
  }

  // ── PUT /api/v1/user/settings ─────────────────────────────────────────────
  @override
  Future<AppSettingsModel> updateAppSettings(AppSettingsModel settings) async {
    final response = await _dataProvider.put(
      ApiUrls.userSettings,
      data: settings.toJson(),
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    final updated = AppSettingsModel.fromJson(map);

    await _prefService.saveAppSettings(updated.toJson());
    return updated;
  }

  // ── Local cache reads ─────────────────────────────────────────────────────
  @override
  UserProfileModel? getCachedProfile() {
    final data = _prefService.getUserData();
    if (data != null) return UserProfileModel.fromJson(data);
    return null;
  }

  @override
  List<VehicleModel>? getCachedVehicles() {
    final list = _prefService.getCachedVehicles();
    if (list != null) return list.map((e) => VehicleModel.fromJson(e)).toList();
    return null;
  }

  @override
  AppSettingsModel? getCachedSettings() {
    final data = _prefService.getAppSettings();
    if (data != null) return AppSettingsModel.fromJson(data);
    return null;
  }
}
