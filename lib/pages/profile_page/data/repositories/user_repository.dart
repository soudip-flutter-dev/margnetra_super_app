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
  Future<VehicleRegistrationResponseModel> registerVehicle(VehicleRegistrationRequestModel request);
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
    if (profile.vehiclesCount > 0) {
      await _prefService.setVehicleRegistered(true);
    }
    return profile;
  }

  @override
  Future<UserProfileModel> updateUserProfile({
    String? fullName,
    String? email,
  }) async {
    final cached = getCachedProfile();
    final updatedData = Data(
      userId: cached?.userId,
      fullName: fullName ?? cached?.fullName,
      phoneNumber: cached?.phoneNumber,
      email: email ?? cached?.email,
      civilScore: cached?.civilScore,
      maxCivilScore: cached?.maxCivilScore,
      civilRating: cached?.civilRating,
      scorePercent: cached?.scorePercent,
      vehiclesCount: cached?.vehiclesCount,
      vehiclesCountText: cached?.vehiclesCountText,
      paymentMethodsText: cached?.paymentMethodsText,
    );
    final updated = UserProfileModel(
      success: true,
      message: 'Profile updated locally',
      data: updatedData,
    );
    await _prefService.saveUserData(updated.toJson());
    return updated;
  }

  @override
  Future<UserProfileModel> uploadAvatar(String filePath) async {
    final cached = getCachedProfile();
    return cached ?? UserProfileModel(success: true, message: 'Avatar updated');
  }

  @override
  Future<CivilScoreModel> getCivilScore() async {
    return const CivilScoreModel(
      currentScore: 85.0,
      streakDays: 7,
      history: [],
    );
  }

  // ── GET /api/vehicles ──────────────────────────────────────────────────
  @override
  Future<List<VehicleModel>> getVehicles() async {
    try {
      final response = await _dataProvider.get(ApiUrls.vehicleRegistration);

      List<dynamic> list = [];
      if (response is Map<String, dynamic>) {
        final data = response['data'];
        if (data is List) {
          list = data;
        } else if (data is Map<String, dynamic>) {
          if (data['vehicles'] is List) {
            list = data['vehicles'] as List;
          } else if (data['vehicle'] is Map<String, dynamic>) {
            list = [data['vehicle']];
          } else if (data.isNotEmpty) {
            list = [data];
          }
        } else if (response['vehicles'] is List) {
          list = response['vehicles'] as List;
        }
      } else if (response is List) {
        list = response;
      }

      final vehicles = list
          .whereType<Map>()
          .map((e) => VehicleModel.fromJson(Map<String, dynamic>.from(e)))
          .where((v) => v.registrationNumber.isNotEmpty)
          .toList();

      if (vehicles.isNotEmpty) {
        await _prefService.saveCachedVehicles(vehicles.map((v) => v.toJson()).toList());
        await _prefService.saveRegisteredVehicle(vehicles.first.toJson());
        await _prefService.setVehicleRegistered(true);
        return vehicles;
      }
    } catch (_) {}

    // Fallback to local DB registered vehicle or cache
    final localVehicle = _prefService.getRegisteredVehicle();
    if (localVehicle != null) {
      final model = VehicleRegistrationData.fromJson(localVehicle).toVehicleModel();
      await _prefService.setVehicleRegistered(true);
      return [model];
    }

    final cached = getCachedVehicles();
    if (cached != null && cached.isNotEmpty) {
      await _prefService.setVehicleRegistered(true);
      return cached;
    }

    return [];
  }

  // ── POST /api/vehicles (Vehicle Registration) ───────────────────────────
  @override
  Future<VehicleRegistrationResponseModel> registerVehicle(
    VehicleRegistrationRequestModel request,
  ) async {
    final response = await _dataProvider.post(
      ApiUrls.vehicleRegistration,
      data: request.toJson(),
    );

    final map = response is Map<String, dynamic>
        ? response
        : <String, dynamic>{};
    final responseModel = VehicleRegistrationResponseModel.fromJson(map);

    // Save registered vehicle in local DB
    final vehicleData = responseModel.data ??
        VehicleRegistrationData(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          registrationNumber: request.registrationNumber,
          vehicleType: request.vehicleType,
          make: request.make,
          model: request.model,
          fuelType: request.fuelType,
          year: request.year,
          chassisNumber: request.chassisNumber,
          createdAt: DateTime.now().toIso8601String(),
          active: true,
          selected: true,
        );

    final vehicle = vehicleData.toVehicleModel();
    await _prefService.saveRegisteredVehicle(vehicleData.toJson());
    await _prefService.setVehicleRegistered(true);

    final currentVehicles = getCachedVehicles() ?? [];
    final updatedList = List<VehicleModel>.from(currentVehicles)
      ..removeWhere((v) =>
          v.registrationNumber.toUpperCase() ==
          vehicle.registrationNumber.toUpperCase())
      ..add(vehicle);
    await _prefService.saveCachedVehicles(updatedList.map((v) => v.toJson()).toList());

    return responseModel;
  }

  // ── POST /api/vehicles ─────────────────────────────────────────────────
  @override
  Future<VehicleModel> addVehicle(VehicleCreateRequest request) async {
    final regRequest = VehicleRegistrationRequestModel(
      registrationNumber: request.registrationNumber,
      vehicleType: request.vehicleType,
      make: request.make,
      model: request.model,
      fuelType: request.fuelType,
      year: request.year,
      chassisNumber: request.chassisNumber,
    );
    final responseModel = await registerVehicle(regRequest);
    if (responseModel.data != null) {
      return responseModel.data!.toVehicleModel();
    }
    throw Exception(responseModel.message ?? 'Failed to register vehicle');
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    return <PaymentMethodModel>[];
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod({
    required String type,
    required String identifier,
  }) async {
    return PaymentMethodModel(
      id: DateTime.now().millisecondsSinceEpoch,
      type: type,
      identifier: identifier,
      isDefault: false,
    );
  }

  @override
  Future<AppSettingsModel> getAppSettings() async {
    final cached = getCachedSettings();
    if (cached != null) return cached;
    return const AppSettingsModel();
  }

  @override
  Future<AppSettingsModel> updateAppSettings(AppSettingsModel settings) async {
    await _prefService.saveAppSettings(settings.toJson());
    return settings;
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
