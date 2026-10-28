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
      id: 1,
      fullName: 'Alice Test',
      phone: '+919876543210',
      email: 'alice@test.com',
      avatarUrl: 'https://cdn.example.com/alice.jpg',
      civilScore: 82.5,
      drivingStreakDays: 14,
      mgcBalance: 250.0,
      isActive: true,
      isVerified: true,
    );
  }

  @override
  Future<UserProfileModel> updateUserProfile({String? fullName, String? email}) async {
    return UserProfileModel(
      id: 1,
      fullName: fullName ?? 'Alice Test',
      phone: '+919876543210',
      email: email ?? 'alice@test.com',
      civilScore: 82.5,
      drivingStreakDays: 14,
      mgcBalance: 250.0,
      isActive: true,
      isVerified: true,
    );
  }

  @override
  Future<UserProfileModel> uploadAvatar(String filePath) async {
    return const UserProfileModel(
      id: 1,
      fullName: 'Alice Test',
      phone: '+919876543210',
      avatarUrl: 'https://cdn.example.com/new_avatar.jpg',
      civilScore: 82.5,
      drivingStreakDays: 14,
      mgcBalance: 250.0,
      isActive: true,
      isVerified: true,
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
  Future<PaymentMethodModel> addPaymentMethod({required String type, required String identifier, bool isPrimary = false}) async {
    return PaymentMethodModel(
      id: 6,
      type: type,
      identifier: identifier,
      isDefault: isPrimary,
    );
  }

  @override
  Future<AppSettingsModel> getAppSettings() async {
    return const AppSettingsModel(
      notificationsEnabled: true,
      locationSharing: true,
      darkMode: true,
      language: 'en',
      hudOverlay: false,
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
      final profile = const UserProfileModel(
        id: 1,
        fullName: 'Bob Smith',
        phone: '9876543210',
        civilScore: 75.0,
        drivingStreakDays: 5,
        mgcBalance: 120.0,
      );
      final json = profile.toJson();
      final decoded = UserProfileModel.fromJson(json);
      expect(decoded.id, 1);
      expect(decoded.fullName, 'Bob Smith');
      expect(decoded.civilScore, 75.0);

      final vehicle = const VehicleModel(
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

      final settings = const AppSettingsModel(
        notificationsEnabled: false,
        darkMode: true,
        language: 'hi',
      );
      final sJson = settings.toJson();
      final sDecoded = AppSettingsModel.fromJson(sJson);
      expect(sDecoded.darkMode, true);
      expect(sDecoded.language, 'hi');
    });

    test('ProfileBloc emits cached state then refreshed state from API', () async {
      mockRepo.cachedProfile = const UserProfileModel(
        id: 1,
        fullName: 'Cached Alice',
        phone: '12345',
        civilScore: 70.0,
        drivingStreakDays: 2,
        mgcBalance: 50.0,
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
