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
  Future<PaymentMethodModel> addPaymentMethod({required String type, required String identifier});
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

  @override
  Future<UserProfileModel> getUserProfile() async {
    final response = await _dataProvider.get(
      ApiUrls.userProfile,
      requiresAuth: true,
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    final profile = UserProfileModel.fromJson(map);

    // Cache profile for offline access
    await _prefService.saveUserData(profile.toJson());
    return profile;
  }

  @override
  Future<UserProfileModel> updateUserProfile({String? fullName, String? email}) async {
    final data = <String, dynamic>{};
    if (fullName != null) data['full_name'] = fullName;
    if (email != null) data['email'] = email;

    final response = await _dataProvider.put(
      ApiUrls.updateProfile,
      data: data,
      requiresAuth: true,
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    final profile = UserProfileModel.fromJson(map);

    await _prefService.saveUserData(profile.toJson());
    return profile;
  }

  @override
  Future<UserProfileModel> uploadAvatar(String filePath) async {
    final response = await _dataProvider.uploadFile(
      ApiUrls.userAvatar,
      filePath: filePath,
      fileFieldName: 'file',
      requiresAuth: true,
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    final profile = UserProfileModel.fromJson(map);

    await _prefService.saveUserData(profile.toJson());
    return profile;
  }

  @override
  Future<CivilScoreModel> getCivilScore() async {
    final response = await _dataProvider.get(
      ApiUrls.userCivilScore,
      requiresAuth: true,
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    return CivilScoreModel.fromJson(map);
  }

  @override
  Future<List<VehicleModel>> getVehicles() async {
    final response = await _dataProvider.get(
      ApiUrls.userVehicles,
      requiresAuth: true,
    );

    final List<dynamic> list = response is List ? response : [];
    final vehicles = list
        .map((e) => VehicleModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    // Cache vehicles list
    await _prefService.saveCachedVehicles(vehicles.map((v) => v.toJson()).toList());
    return vehicles;
  }

  @override
  Future<VehicleModel> addVehicle(VehicleCreateRequest request) async {
    final response = await _dataProvider.post(
      ApiUrls.userVehicles,
      data: request.toJson(),
      requiresAuth: true,
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    return VehicleModel.fromJson(map);
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    final response = await _dataProvider.get(
      ApiUrls.userPaymentMethods,
      requiresAuth: true,
    );

    final List<dynamic> list = response is List ? response : [];
    return list
        .map((e) => PaymentMethodModel.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod({
    required String type,
    required String identifier,
  }) async {
    final response = await _dataProvider.post(
      ApiUrls.userPaymentMethods,
      data: {
        'type': type,
        'identifier': identifier,
      },
      requiresAuth: true,
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    return PaymentMethodModel.fromJson(map);
  }

  @override
  Future<AppSettingsModel> getAppSettings() async {
    final response = await _dataProvider.get(
      ApiUrls.userSettings,
      requiresAuth: true,
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    final settings = AppSettingsModel.fromJson(map);

    await _prefService.saveAppSettings(settings.toJson());
    return settings;
  }

  @override
  Future<AppSettingsModel> updateAppSettings(AppSettingsModel settings) async {
    final response = await _dataProvider.put(
      ApiUrls.userSettings,
      data: settings.toJson(),
      requiresAuth: true,
    );

    final map = response is Map<String, dynamic> ? response : <String, dynamic>{};
    final updated = AppSettingsModel.fromJson(map);

    await _prefService.saveAppSettings(updated.toJson());
    return updated;
  }

  @override
  UserProfileModel? getCachedProfile() {
    final data = _prefService.getUserData();
    if (data != null) {
      return UserProfileModel.fromJson(data);
    }
    return null;
  }

  @override
  List<VehicleModel>? getCachedVehicles() {
    final list = _prefService.getCachedVehicles();
    if (list != null) {
      return list.map((e) => VehicleModel.fromJson(e)).toList();
    }
    return null;
  }

  @override
  AppSettingsModel? getCachedSettings() {
    final data = _prefService.getAppSettings();
    if (data != null) {
      return AppSettingsModel.fromJson(data);
    }
    return null;
  }
}
