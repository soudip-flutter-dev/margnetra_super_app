import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:margnetra_super_app/core/app_services/api_services/api_urls.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/data/models/telemetry_socket_model.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/data/services/telemetry_socket_service.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/speedometer_page/logic/blocs/speedometer_socket_bloc/speedometer_socket_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPrefService.init();
  });

  group('TelemetrySocketModel Tests', () {
    test('Serializes exactly to requested JSON payload format', () {
      const payload = {
        "vehicleId": "ee344c8c-b968-421e-a3ed-65a0e6c9aa81",
        "gps": {
          "latitude": 22.5740,
          "longitude": 88.3650,
          "speedKmh": 72.5,
        },
        "vehicle": {
          "rpm": 2600,
        },
      };

      final model = TelemetrySocketModel.fromJson(payload);

      expect(model.vehicleId, "ee344c8c-b968-421e-a3ed-65a0e6c9aa81");
      expect(model.gps.latitude, 22.5740);
      expect(model.gps.longitude, 88.3650);
      expect(model.gps.speedKmh, 72.5);
      expect(model.vehicle.rpm, 2600);

      final serialized = model.toJson();
      expect(serialized, equals(payload));

      final jsonString = jsonEncode(serialized);
      expect(jsonString, contains('"vehicleId":"ee344c8c-b968-421e-a3ed-65a0e6c9aa81"'));
      expect(jsonString, contains('"speedKmh":72.5'));
      expect(jsonString, contains('"rpm":2600'));
    });

    test('Handles empty and partial JSON maps gracefully', () {
      final model = TelemetrySocketModel.fromJson({});
      expect(model.vehicleId, isEmpty);
      expect(model.gps.speedKmh, 0.0);
      expect(model.gps.latitude, 0.0);
      expect(model.vehicle.rpm, 0);
    });
  });

  group('Telemetry Socket URL Builder Tests', () {
    test('Generates telemetry WebSocket URL with custom and default token', () {
      final defaultUrl = ApiUrls.getTelemetrySocketUrl();
      expect(defaultUrl, startsWith('ws://localhost:8080/ws/telemetry?token='));
      expect(defaultUrl, contains(ApiUrls.defaultTelemetryToken));

      const customToken = 'my_custom_jwt_token';
      final customUrl = ApiUrls.getTelemetrySocketUrl(token: customToken);
      expect(customUrl, equals('ws://localhost:8080/ws/telemetry?token=my_custom_jwt_token'));
    });
  });

  group('SpeedometerSocketBloc Tests', () {
    test('Initial state is SpeedometerSocketInitial', () {
      final bloc = SpeedometerSocketBloc();
      expect(bloc.state, isA<SpeedometerSocketInitial>());
      expect(bloc.state.status, SocketConnectionStatus.disconnected);
      expect(bloc.state.isConnected, isFalse);
      bloc.close();
    });

    test('Sending telemetry event updates state with latest telemetry', () async {
      final bloc = SpeedometerSocketBloc();

      final telemetry = TelemetrySocketModel(
        vehicleId: "ee344c8c-b968-421e-a3ed-65a0e6c9aa81",
        gps: const GpsTelemetry(
          latitude: 22.5740,
          longitude: 88.3650,
          speedKmh: 72.5,
        ),
        vehicle: const VehicleTelemetry(
          rpm: 2600,
        ),
      );

      bloc.add(SpeedometerSocketSendTelemetry(telemetry: telemetry));

      await expectLater(
        bloc.stream,
        emits(predicate<SpeedometerSocketState>((state) {
          return state.telemetry?.vehicleId == "ee344c8c-b968-421e-a3ed-65a0e6c9aa81" &&
              state.currentSpeedKmh == 72.5 &&
              state.currentRpm == 2600 &&
              state.latitude == 22.5740 &&
              state.longitude == 88.3650;
        })),
      );

      bloc.close();
    });

    test('SpeedometerSocketSendCurrentData computes telemetry and RPM accurately', () async {
      final bloc = SpeedometerSocketBloc();

      bloc.add(const SpeedometerSocketSendCurrentData(
        speedKmh: 80.0,
        latitude: 22.5740,
        longitude: 88.3650,
        rpm: 2800,
        vehicleId: 'test-vehicle-id',
      ));

      await expectLater(
        bloc.stream,
        emits(predicate<SpeedometerSocketState>((state) {
          return state.telemetry?.vehicleId == 'test-vehicle-id' &&
              state.currentSpeedKmh == 80.0 &&
              state.currentRpm == 2800;
        })),
      );

      bloc.close();
    });
  });
}

