import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'speed_filter.dart';

/// Represents the status of location services and permissions.
enum SpeedServiceStatus {
  initial,
  checking,
  serviceDisabled,
  permissionDenied,
  permissionDeniedForever,
  active,
  error,
}

/// Unit of measurement for displaying speed.
enum SpeedUnit {
  kmh,
  mph;

  String get label => this == SpeedUnit.kmh ? 'km/h' : 'mph';

  /// Convert speed from m/s to the selected unit.
  /// km/h: m/s * 3.6
  /// mph:  m/s * 2.237
  double convertFromMps(double mps) {
    switch (this) {
      case SpeedUnit.kmh:
        return mps * 3.6;
      case SpeedUnit.mph:
        return mps * 2.237;
    }
  }

  /// Gauge maximum scale recommendation.
  double get maxGaugeValue => this == SpeedUnit.kmh ? 240.0 : 150.0;
}

/// SpeedService manages GPS location streaming, permissions, smoothing, and error reporting.
class SpeedService {
  final SpeedFilter _filter = SpeedFilter(windowSize: 3, jitterThresholdKmh: 1.5);

  final StreamController<double> _speedController = StreamController<double>.broadcast();
  final StreamController<SpeedServiceStatus> _statusController =
      StreamController<SpeedServiceStatus>.broadcast();

  StreamSubscription<Position>? _positionSubscription;
  SpeedServiceStatus _status = SpeedServiceStatus.initial;
  String? _errorMessage;

  /// Stream of smoothed speed in meters per second (m/s).
  Stream<double> get speedStream => _speedController.stream;

  /// Stream of service/permission status changes.
  Stream<SpeedServiceStatus> get statusStream => _statusController.stream;

  /// Current status snapshot.
  SpeedServiceStatus get currentStatus => _status;

  /// Last error message, if any.
  String? get errorMessage => _errorMessage;

  void _updateStatus(SpeedServiceStatus status, [String? error]) {
    _status = status;
    _errorMessage = error;
    if (!_statusController.isClosed) {
      _statusController.add(status);
    }
  }

  /// Checks device location service and runtime permissions, then begins listening to GPS stream.
  Future<SpeedServiceStatus> startTracking() async {
    _updateStatus(SpeedServiceStatus.checking);

    try {
      // 1. Verify device location service is turned on
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _updateStatus(SpeedServiceStatus.serviceDisabled);
        return _status;
      }

      // 2. Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _updateStatus(SpeedServiceStatus.permissionDenied);
          return _status;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _updateStatus(SpeedServiceStatus.permissionDeniedForever);
        return _status;
      }

      // 3. Permission granted -> start position stream
      _filter.reset();
      await _positionSubscription?.cancel();

      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0,
      );

      _positionSubscription = Geolocator.getPositionStream(
        locationSettings: locationSettings,
      ).listen(
        (Position position) {
          // Process raw speed (treat negative values as 0, smooth 3 readings, suppress < 1.5 km/h)
          final double smoothedSpeedMps = _filter.process(position.speed);
          if (!_speedController.isClosed) {
            _speedController.add(smoothedSpeedMps);
          }
        },
        onError: (dynamic error) {
          _updateStatus(SpeedServiceStatus.error, error.toString());
        },
      );

      _updateStatus(SpeedServiceStatus.active);
      return _status;
    } catch (e) {
      _updateStatus(SpeedServiceStatus.error, e.toString());
      return _status;
    }
  }

  /// Opens the device app settings screen (for permanently denied permissions).
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }

  /// Opens the device system location settings (to enable GPS).
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  /// Stops tracking GPS speed and resets filter.
  Future<void> stopTracking() async {
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    _filter.reset();
  }

  /// Disposes internal controllers and subscriptions.
  void dispose() {
    stopTracking();
    _speedController.close();
    _statusController.close();
  }
}
