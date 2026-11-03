import 'package:equatable/equatable.dart';

/// Telemetry model for real-time speedometer WebSocket communication.
class TelemetrySocketModel extends Equatable {
  final String vehicleId;
  final GpsTelemetry gps;
  final VehicleTelemetry vehicle;

  const TelemetrySocketModel({
    required this.vehicleId,
    required this.gps,
    required this.vehicle,
  });

  /// Factory from JSON map with null-safe fallbacks.
  factory TelemetrySocketModel.fromJson(Map<String, dynamic> json) {
    return TelemetrySocketModel(
      vehicleId: json['vehicleId']?.toString() ?? '',
      gps: json['gps'] is Map<String, dynamic>
          ? GpsTelemetry.fromJson(json['gps'] as Map<String, dynamic>)
          : GpsTelemetry.empty(),
      vehicle: json['vehicle'] is Map<String, dynamic>
          ? VehicleTelemetry.fromJson(json['vehicle'] as Map<String, dynamic>)
          : VehicleTelemetry.empty(),
    );
  }

  /// Converts the telemetry model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'vehicleId': vehicleId,
      'gps': gps.toJson(),
      'vehicle': vehicle.toJson(),
    };
  }

  TelemetrySocketModel copyWith({
    String? vehicleId,
    GpsTelemetry? gps,
    VehicleTelemetry? vehicle,
  }) {
    return TelemetrySocketModel(
      vehicleId: vehicleId ?? this.vehicleId,
      gps: gps ?? this.gps,
      vehicle: vehicle ?? this.vehicle,
    );
  }

  @override
  List<Object?> get props => [vehicleId, gps, vehicle];
}

/// GPS coordinates and speed telemetry.
class GpsTelemetry extends Equatable {
  final double latitude;
  final double longitude;
  final double speedKmh;

  const GpsTelemetry({
    required this.latitude,
    required this.longitude,
    required this.speedKmh,
  });

  factory GpsTelemetry.empty() => const GpsTelemetry(
        latitude: 0.0,
        longitude: 0.0,
        speedKmh: 0.0,
      );

  factory GpsTelemetry.fromJson(Map<String, dynamic> json) {
    return GpsTelemetry(
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      speedKmh: (json['speedKmh'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'speedKmh': speedKmh,
    };
  }

  GpsTelemetry copyWith({
    double? latitude,
    double? longitude,
    double? speedKmh,
  }) {
    return GpsTelemetry(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      speedKmh: speedKmh ?? this.speedKmh,
    );
  }

  @override
  List<Object?> get props => [latitude, longitude, speedKmh];
}

/// Vehicle engine and internal sensor telemetry.
class VehicleTelemetry extends Equatable {
  final int rpm;

  const VehicleTelemetry({
    required this.rpm,
  });

  factory VehicleTelemetry.empty() => const VehicleTelemetry(rpm: 0);

  factory VehicleTelemetry.fromJson(Map<String, dynamic> json) {
    return VehicleTelemetry(
      rpm: (json['rpm'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rpm': rpm,
    };
  }

  VehicleTelemetry copyWith({
    int? rpm,
  }) {
    return VehicleTelemetry(
      rpm: rpm ?? this.rpm,
    );
  }

  @override
  List<Object?> get props => [rpm];
}

