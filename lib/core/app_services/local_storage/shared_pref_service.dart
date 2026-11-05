import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:margnetra_super_app/core/app_constants/shared_pref_keys.dart';

class SharedPrefService {
  static SharedPrefService? _instance;
  static SharedPreferences? _prefs;

  SharedPrefService._();

  static SharedPrefService get instance {
    _instance ??= SharedPrefService._();
    return _instance!;
  }

  /// Initialize SharedPreferences instance (call in main.dart before runApp)
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw StateError(
        'SharedPrefService is not initialized. Call SharedPrefService.init() in main().',
      );
    }
    return _prefs!;
  }

  // ==================== Generic Getters & Setters ====================

  Future<bool> setString(String key, String value) async =>
      await _preferences.setString(key, value);

  String? getString(String key, {String? defaultValue}) =>
      _preferences.getString(key) ?? defaultValue;

  Future<bool> setInt(String key, int value) async =>
      await _preferences.setInt(key, value);

  int? getInt(String key, {int? defaultValue}) =>
      _preferences.getInt(key) ?? defaultValue;

  Future<bool> setBool(String key, bool value) async =>
      await _preferences.setBool(key, value);

  bool getBool(String key, {bool defaultValue = false}) =>
      _preferences.getBool(key) ?? defaultValue;

  Future<bool> setDouble(String key, double value) async =>
      await _preferences.setDouble(key, value);

  double? getDouble(String key, {double? defaultValue}) =>
      _preferences.getDouble(key) ?? defaultValue;

  Future<bool> setStringList(String key, List<String> value) async =>
      await _preferences.setStringList(key, value);

  List<String>? getStringList(String key) =>
      _preferences.getStringList(key);

  Future<bool> setJson(String key, Map<String, dynamic> jsonMap) async =>
      await _preferences.setString(key, jsonEncode(jsonMap));

  Map<String, dynamic>? getJson(String key) {
    final raw = _preferences.getString(key);
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> remove(String key) async => await _preferences.remove(key);

  Future<bool> clearAll() async => await _preferences.clear();

  bool containsKey(String key) => _preferences.containsKey(key);

  // ==================== Auth & User Helpers ====================

  Future<bool> saveAuthToken(String token) async =>
      await setString(SharedPrefKeys.accessToken, token);

  String? getAuthToken() => getString(SharedPrefKeys.accessToken);

  Future<bool> saveRefreshToken(String token) async =>
      await setString(SharedPrefKeys.refreshToken, token);

  String? getRefreshToken() => getString(SharedPrefKeys.refreshToken);

  Future<bool> setLoggedIn(bool value) async =>
      await setBool(SharedPrefKeys.isLoggedIn, value);

  bool get isLoggedIn => getBool(SharedPrefKeys.isLoggedIn, defaultValue: false);

  Future<bool> saveUserId(String userId) async =>
      await setString(SharedPrefKeys.userId, userId);

  String? getUserId() => getString(SharedPrefKeys.userId);

  Future<bool> saveUserData(Map<String, dynamic> data) async =>
      await setJson(SharedPrefKeys.userProfile, data);

  Map<String, dynamic>? getUserData() => getJson(SharedPrefKeys.userProfile);

  Future<bool> saveAppSettings(Map<String, dynamic> data) async =>
      await setJson(SharedPrefKeys.appSettings, data);

  Map<String, dynamic>? getAppSettings() => getJson(SharedPrefKeys.appSettings);

  Future<bool> saveCachedVehicles(List<Map<String, dynamic>> vehicles) async =>
      await setString(SharedPrefKeys.cachedVehicles, jsonEncode(vehicles));

  List<Map<String, dynamic>>? getCachedVehicles() {
    final raw = getString(SharedPrefKeys.cachedVehicles);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveCachedDocuments(List<Map<String, dynamic>> docs) async =>
      await setString(SharedPrefKeys.cachedDocuments, jsonEncode(docs));

  List<Map<String, dynamic>>? getCachedDocuments() {
    final raw = getString(SharedPrefKeys.cachedDocuments);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveCachedWalletDashboard(Map<String, dynamic> data) async =>
      await setJson(SharedPrefKeys.cachedWalletDashboard, data);

  Map<String, dynamic>? getCachedWalletDashboard() =>
      getJson(SharedPrefKeys.cachedWalletDashboard);

  Future<bool> saveRegisteredVehicle(Map<String, dynamic> vehicle) async {
    await setJson(SharedPrefKeys.registeredVehicle, vehicle);
    await setBool(SharedPrefKeys.isVehicleRegistered, true);
    return true;
  }

  Map<String, dynamic>? getRegisteredVehicle() =>
      getJson(SharedPrefKeys.registeredVehicle);

  Future<bool> setVehicleRegistered(bool value) async =>
      await setBool(SharedPrefKeys.isVehicleRegistered, value);

  bool get isVehicleRegistered {
    final flag = getBool(SharedPrefKeys.isVehicleRegistered, defaultValue: false);
    if (flag) return true;
    if (getRegisteredVehicle() != null) return true;
    final cached = getCachedVehicles();
    return cached != null && cached.isNotEmpty;
  }

  /// Clears user authentication session data while preserving registered vehicle & app preferences
  Future<void> clearAuthSession() async {
    await remove(SharedPrefKeys.accessToken);
    await remove(SharedPrefKeys.refreshToken);
    await remove(SharedPrefKeys.userId);
    await remove(SharedPrefKeys.userProfile);
    await setBool(SharedPrefKeys.isLoggedIn, false);
  }
}
