import 'package:equatable/equatable.dart';

class VehicleModel extends Equatable {
  final dynamic id;
  final String? userId;
  final String registrationNumber;
  final String make;
  final String model;
  final String vehicleType;
  final int year;
  final String fuelType;
  final bool isPrimary;
  final String? chassisNumber;
  final DateTime? insuranceExpiry;
  final DateTime? pucExpiry;
  final DateTime? createdAt;

  const VehicleModel({
    required this.id,
    this.userId,
    required this.registrationNumber,
    required this.make,
    required this.model,
    this.vehicleType = 'CAR',
    required this.year,
    this.fuelType = 'PETROL',
    this.isPrimary = false,
    this.chassisNumber,
    this.insuranceExpiry,
    this.pucExpiry,
    this.createdAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] ?? '',
      userId: json['userId']?.toString() ?? json['user_id']?.toString(),
      registrationNumber: json['registrationNumber']?.toString() ??
          json['registration_number']?.toString() ??
          '',
      make: json['make']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      vehicleType: json['vehicleType']?.toString() ??
          json['vehicle_type']?.toString() ??
          'CAR',
      year: json['year'] is int
          ? json['year'] as int
          : int.tryParse(json['year']?.toString() ?? '2023') ?? 2023,
      fuelType: json['fuelType']?.toString() ??
          json['fuel_type']?.toString() ??
          'PETROL',
      isPrimary: (json['isPrimary'] ?? json['is_primary'] ?? json['selected'] ?? false) as bool,
      chassisNumber: json['chassisNumber']?.toString() ?? json['chassis_number']?.toString(),
      insuranceExpiry: json['insuranceExpiry'] != null || json['insurance_expiry'] != null
          ? DateTime.tryParse((json['insuranceExpiry'] ?? json['insurance_expiry']).toString())
          : null,
      pucExpiry: json['pucExpiry'] != null || json['puc_expiry'] != null
          ? DateTime.tryParse((json['pucExpiry'] ?? json['puc_expiry']).toString())
          : null,
      createdAt: json['createdAt'] != null || json['created_at'] != null
          ? DateTime.tryParse((json['createdAt'] ?? json['created_at']).toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'registrationNumber': registrationNumber,
      'registration_number': registrationNumber,
      'make': make,
      'model': model,
      'vehicleType': vehicleType,
      'year': year,
      'fuelType': fuelType,
      'fuel_type': fuelType,
      'is_primary': isPrimary,
      'isPrimary': isPrimary,
      'chassisNumber': chassisNumber,
      'insurance_expiry': insuranceExpiry?.toIso8601String().split('T').first,
      'puc_expiry': pucExpiry?.toIso8601String().split('T').first,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        registrationNumber,
        make,
        model,
        vehicleType,
        year,
        fuelType,
        isPrimary,
        chassisNumber,
        insuranceExpiry,
        pucExpiry,
        createdAt,
      ];
}

class VehicleCreateRequest {
  final String registrationNumber;
  final String make;
  final String model;
  final String vehicleType;
  final String fuelType;
  final int year;
  final bool isPrimary;
  final String? chassisNumber;

  const VehicleCreateRequest({
    required this.registrationNumber,
    required this.make,
    required this.model,
    this.vehicleType = 'CAR',
    this.fuelType = 'PETROL',
    required this.year,
    this.isPrimary = true,
    this.chassisNumber,
  });

  Map<String, dynamic> toJson() {
    String formattedFuel = fuelType.toUpperCase();
    if (formattedFuel == 'EV') formattedFuel = 'ELECTRIC';

    String formattedType = vehicleType.toUpperCase();
    if (formattedType.isEmpty) formattedType = 'CAR';

    final map = <String, dynamic>{
      'registrationNumber': registrationNumber.toUpperCase().replaceAll(' ', ''),
      'make': make.trim(),
      'model': model.trim(),
      'vehicleType': formattedType,
      'fuelType': formattedFuel,
      'year': year,
      'isPrimary': isPrimary,
    };
    if (chassisNumber != null && chassisNumber!.trim().isNotEmpty) {
      map['chassisNumber'] = chassisNumber!.trim().toUpperCase();
    }
    return map;
  }
}
