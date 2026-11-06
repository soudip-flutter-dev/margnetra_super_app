import 'package:flutter_test/flutter_test.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/profile_models.dart';
import 'package:margnetra_super_app/pages/profile_page/data/repositories/user_repository.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/profile_bloc/profile_bloc.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/vehicle_bloc/vehicle_bloc.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/settings_bloc/settings_bloc.dart';

class MockUserRepository implements IUserRepository {
  UserProfileModel? cachedProfile;
  List<VehicleModel>? cachedVehicles;
  AppSettingsModel? cachedSettings;

  bool shouldFail = false;

  @override
  UserProfileModel? getCachedProfile() => cachedProfile;

  @override
  List<VehicleModel>? getCachedVehicles() => cachedVehicles;

  @override
  AppSettingsModel? getCachedSettings() => cachedSettings;

  @override
  Future<UserProfileModel> getUserProfile() async {
    if (shouldFail) throw Exception('Network error');
    return const UserProfileModel(
      success: true,
      message: 'Profile loaded',
      data: Data(
        userId: '1',
        fullName: 'Alice Test',
        phoneNumber: '+919876543210',
        email: 'alice@test.com',
        civilScore: 82,
      ),
    );
  }

  @override
  Future<UserProfileUpdateResponseModel> updateProfile(
    UserProfileUpdateRequestModel request,
  ) async {
    return UserProfileUpdateResponseModel(
      success: true,
      message: 'User registered successfully',
      data: Data(
        userId: '3fa85f64-5717-4562-b3fc-2c963f66afa6',
        fullName: request.fullName ?? 'Amit Sharma',
        phoneNumber: '+919876543210',
        email: request.email ?? 'amit.sharma@example.com',
        civilScore: 0,
        maxCivilScore: 0,
        civilRating: 'Good',
        scorePercent: 0,
        vehiclesCount: 0,
        vehiclesCountText: '0 Vehicles',
        paymentMethodsText: 'None',
        username: request.username ?? 'Amit Sharma',
      ),
    );
  }

  @override
  Future<UserProfileModel> updateUserProfile({
    String? fullName,
    String? email,
    String? username,
    String? effectiveName,
    String? cleanEmail,
    UserProfileUpdateRequestModel? request,
  }) async {
    final effectiveUsername = username ?? request?.username ?? fullName ?? 'Amit Sharma';
    final effectiveFullName = fullName ?? request?.fullName ?? 'Amit Sharma';
    final effectiveEmail = email ?? request?.email ?? 'amit.sharma@example.com';
    return UserProfileModel(
      success: true,
      message: 'Profile updated',
      data: Data(
        userId: '1',
        fullName: effectiveFullName,
        username: effectiveUsername,
        phoneNumber: '+919876543210',
        email: effectiveEmail,
        civilScore: 82,
      ),
    );
  }

  @override
  Future<UserProfileModel> uploadAvatar(String filePath) async {
    return const UserProfileModel(
      success: true,
      message: 'Avatar uploaded',
      data: Data(
        userId: '1',
        fullName: 'Alice Test',
        phoneNumber: '+919876543210',
        email: 'alice@test.com',
        civilScore: 82,
      ),
    );
  }

  @override
  Future<CivilScoreModel> getCivilScore() async {
    return const CivilScoreModel(
      currentScore: 82.5,
      streakDays: 14,
      history: [],
    );
  }

  @override
  Future<List<VehicleModel>> getVehicles() async {
    return const [
      VehicleModel(
        id: 10,
        registrationNumber: 'DL01AB1234',
        make: 'Hyundai',
        model: 'i20',
        year: 2022,
        fuelType: 'petrol',
        isPrimary: true,
      )
    ];
  }

  @override
  Future<VehicleRegistrationResponseModel> registerVehicle(
    VehicleRegistrationRequestModel request,
  ) async {
    return VehicleRegistrationResponseModel(
      success: true,
      message: 'Vehicle registered successfully',
      data: VehicleRegistrationData(
        id: 'mock-id-123',
        registrationNumber: request.registrationNumber,
        vehicleType: request.vehicleType,
        make: request.make,
        model: request.model,
        fuelType: request.fuelType,
        year: request.year,
        chassisNumber: request.chassisNumber,
      ),
    );
  }

  @override
  Future<VehicleModel> addVehicle(VehicleCreateRequest request) async {
    return VehicleModel(
      id: 11,
      registrationNumber: request.registrationNumber,
      make: request.make,
      model: request.model,
      year: request.year,
      fuelType: request.fuelType,
      isPrimary: request.isPrimary,
    );
  }

  @override
  Future<List<PaymentMethodModel>> getPaymentMethods() async {
    return const [
      PaymentMethodModel(
        id: 5,
        type: 'upi',
        identifier: 'alice@okaxis',
        isDefault: true,
      )
    ];
  }

  @override
  Future<PaymentMethodModel> addPaymentMethod({
    required String type,
    required String identifier,
  }) async {
    return PaymentMethodModel(
      id: 6,
      type: type,
      identifier: identifier,
      isDefault: false,
    );
  }

  @override
  Future<AppSettingsModel> getAppSettings() async {
    return const AppSettingsModel(
      notificationsEnabled: true,
      darkMode: false,
      language: 'en',
    );
  }

  @override
  Future<AppSettingsModel> updateAppSettings(AppSettingsModel settings) async {
    return settings;
  }
}

void main() {
  group('Profile and Settings Verification Tests', () {
    late MockUserRepository mockRepo;

    setUp(() {
      mockRepo = MockUserRepository();
    });

    test('Data Models JSON roundtrip serialization', () {
      const profile = UserProfileModel(
        success: true,
        message: 'Success',
        data: Data(
          userId: '1',
          fullName: 'Bob Smith',
          phoneNumber: '9876543210',
          civilScore: 75,
        ),
      );
      final json = profile.toJson();
      final decoded = UserProfileModel.fromJson(json);
      expect(decoded.userId, '1');
      expect(decoded.fullName, 'Bob Smith');
      expect(decoded.civilScore, 75);

      const vehicle = VehicleModel(
        id: 2,
        registrationNumber: 'KA05MH9999',
        make: 'Tata',
        model: 'Nexon',
        year: 2023,
        fuelType: 'ev',
        isPrimary: true,
      );
      final vJson = vehicle.toJson();
      final vDecoded = VehicleModel.fromJson(vJson);
      expect(vDecoded.registrationNumber, 'KA05MH9999');
      expect(vDecoded.fuelType, 'ev');

      const settings = AppSettingsModel(
        notificationsEnabled: false,
        darkMode: true,
        language: 'hi',
      );
      final sJson = settings.toJson();
      final sDecoded = AppSettingsModel.fromJson(sJson);
      expect(sDecoded.darkMode, true);
      expect(sDecoded.language, 'hi');
    });

    test('Parses user profile API response correctly matching backend contract', () {
      final jsonResponse = {
        "success": true,
        "message": "User profile retrieved successfully",
        "data": {
          "userId": "a8a49e7c-9cf2-4cd1-977d-89c7503aeaf5",
          "fullName": "Chandsii Solanki",
          "phoneNumber": "+919831674368",
          "email": "chandsi@gmail.com",
          "civilScore": 750,
          "maxCivilScore": 1000,
          "civilRating": "Good Driver. Maintain safe speeds.",
          "scorePercent": 0.75,
          "vehiclesCount": 2,
          "vehiclesCountText": "2 Vehicles",
          "paymentMethodsText": "UPI, Cards",
          "username": "Chandsii Solanki"
        }
      };

      final profile = UserProfileModel.fromJson(jsonResponse);
      expect(profile.success, isTrue);
      expect(profile.message, "User profile retrieved successfully");
      expect(profile.userId, "a8a49e7c-9cf2-4cd1-977d-89c7503aeaf5");
      expect(profile.fullName, "Chandsii Solanki");
      expect(profile.username, "Chandsii Solanki");
      expect(profile.phoneNumber, "+919831674368");
      expect(profile.email, "chandsi@gmail.com");
      expect(profile.civilScore, 750);
      expect(profile.maxCivilScore, 1000);
      expect(profile.civilRating, "Good Driver. Maintain safe speeds.");
      expect(profile.scorePercent, 0.75);
      expect(profile.vehiclesCount, 2);
      expect(profile.vehiclesCountText, "2 Vehicles");
      expect(profile.paymentMethodsText, "UPI, Cards");

      final serialized = profile.toJson();
      expect(serialized['success'], isTrue);
      expect(serialized['data']['username'], "Chandsii Solanki");
    });

    test('Parses UserProfileUpdateRequestModel and UserProfileUpdateResponseModel correctly', () {
      final reqJson = {
        "username": "Amit Sharma",
        "fullName": "Amit Sharma",
        "email": "amit.sharma@example.com",
        "effectiveName": "string",
        "cleanEmail": "string"
      };

      final reqModel = UserProfileUpdateRequestModel.fromJson(reqJson);
      expect(reqModel.username, "Amit Sharma");
      expect(reqModel.fullName, "Amit Sharma");
      expect(reqModel.email, "amit.sharma@example.com");
      expect(reqModel.effectiveName, "string");
      expect(reqModel.cleanEmail, "string");

      final reqSerialized = reqModel.toJson();
      expect(reqSerialized['username'], "Amit Sharma");
      expect(reqSerialized['fullName'], "Amit Sharma");
      expect(reqSerialized['email'], "amit.sharma@example.com");

      final resJson = {
        "success": true,
        "message": "User registered successfully",
        "data": {
          "userId": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          "fullName": "string",
          "phoneNumber": "string",
          "email": "string",
          "civilScore": 0,
          "maxCivilScore": 0,
          "civilRating": "string",
          "scorePercent": 0,
          "vehiclesCount": 0,
          "vehiclesCountText": "string",
          "paymentMethodsText": "string",
          "username": "Amit Sharma"
        }
      };

      final resModel = UserProfileUpdateResponseModel.fromJson(resJson);
      expect(resModel.success, isTrue);
      expect(resModel.message, "User registered successfully");
      expect(resModel.userId, "3fa85f64-5717-4562-b3fc-2c963f66afa6");
      expect(resModel.username, "Amit Sharma");
      expect(resModel.fullName, "string");
      expect(resModel.civilScore, 0);

      final userProfile = resModel.toUserProfileModel();
      expect(userProfile.userId, "3fa85f64-5717-4562-b3fc-2c963f66afa6");
      expect(userProfile.username, "Amit Sharma");
    });

    test('ProfileBloc handles UpdateProfileEvent with UserProfileUpdateRequestModel', () async {
      final bloc = ProfileBloc(userRepository: mockRepo);
      final states = <ProfileState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const UpdateProfileEvent(
        username: 'Amit Sharma',
        fullName: 'Amit Sharma',
        email: 'amit.sharma@example.com',
      ));
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.any((s) => s is ProfileLoaded && s.profile.username == 'Amit Sharma'), isTrue);

      await sub.cancel();
      await bloc.close();
    });

    test('ProfileBloc emits cached state then refreshed state from API', () async {
      mockRepo.cachedProfile = const UserProfileModel(
        success: true,
        message: 'Cached',
        data: Data(
          userId: '1',
          fullName: 'Cached Alice',
          phoneNumber: '12345',
          civilScore: 70,
        ),
      );

      final bloc = ProfileBloc(userRepository: mockRepo);

      final states = <ProfileState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const LoadProfileEvent(forceRefresh: false));
      await Future.delayed(const Duration(milliseconds: 100));

      expect(states.isNotEmpty, true);
      expect(states.first is ProfileLoaded, true);
      expect((states.first as ProfileLoaded).profile.fullName, 'Cached Alice');

      final lastState = states.last as ProfileLoaded;
      expect(lastState.profile.fullName, 'Alice Test');
      expect(lastState.civilScore?.currentScore, 82.5);
      expect(lastState.paymentMethods.length, 1);

      await sub.cancel();
      await bloc.close();
    });

    test('VehicleBloc loads vehicles and handles add vehicle event', () async {
      final bloc = VehicleBloc(userRepository: mockRepo);
      final states = <VehicleState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const LoadVehiclesEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.any((s) => s is VehicleLoaded && s.vehicles.length == 1), true);

      bloc.add(const AddVehicleEvent(VehicleCreateRequest(
        registrationNumber: 'MH02CD5678',
        make: 'Honda',
        model: 'City',
        year: 2021,
        fuelType: 'petrol',
      )));
      await Future.delayed(const Duration(milliseconds: 50));

      expect(states.any((s) => s is VehicleAddSuccess && s.vehicle.registrationNumber == 'MH02CD5678'), true);

      await sub.cancel();
      await bloc.close();
    });

    test('SettingsBloc performs optimistic updates then syncs to backend', () async {
      final bloc = SettingsBloc(userRepository: mockRepo);
      final states = <SettingsState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const LoadSettingsEvent());
      await Future.delayed(const Duration(milliseconds: 50));

      bloc.add(const UpdateSettingToggleEvent(darkMode: true, language: 'hi'));
      await Future.delayed(const Duration(milliseconds: 50));

      final loadedStates = states.whereType<SettingsLoaded>().toList();
      expect(loadedStates.isNotEmpty, true);
      expect(loadedStates.last.settings.darkMode, true);
      expect(loadedStates.last.settings.language, 'hi');

      await sub.cancel();
      await bloc.close();
    });
  });
}
