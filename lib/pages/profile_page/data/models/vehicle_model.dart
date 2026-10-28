import 'package:equatable/equatable.dart';

class VehicleModel extends Equatable {
  final int id;
  final int? userId;
  final String registrationNumber;
  final String make;
  final String model;
  final int year;
  final String fuelType;
  final bool isPrimary;
  final DateTime? insuranceExpiry;
  final DateTime? pucExpiry;
  final DateTime? createdAt;

  const VehicleModel({
    required this.id,
    this.userId,
    required this.registrationNumber,
    required this.make,
    required this.model,
    required this.year,
    this.fuelType = 'petrol',
    this.isPrimary = false,
    this.insuranceExpiry,
    this.pucExpiry,
    this.createdAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: json['user_id'] is int ? json['user_id'] as int : int.tryParse(json['user_id']?.toString() ?? ''),
      registrationNumber: json['registration_number']?.toString() ?? '',
      make: json['make']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      year: json['year'] is int ? json['year'] as int : int.tryParse(json['year']?.toString() ?? '2022') ?? 2022,
      fuelType: json['fuel_type']?.toString() ?? 'petrol',
      isPrimary: json['is_primary'] as bool? ?? false,
      insuranceExpiry: json['insurance_expiry'] != null
          ? DateTime.tryParse(json['insurance_expiry'].toString())
          : null,
      pucExpiry: json['puc_expiry'] != null
          ? DateTime.tryParse(json['puc_expiry'].toString())
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'registration_number': registrationNumber,
      'make': make,
      'model': model,
      'year': year,
      'fuel_type': fuelType,
      'is_primary': isPrimary,
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
        year,
        fuelType,
        isPrimary,
        insuranceExpiry,
        pucExpiry,
        createdAt,
      ];
}

class VehicleCreateRequest {
  final String registrationNumber;
  final String make;
  final String model;
  final int year;
  final String fuelType;
  final bool isPrimary;

  const VehicleCreateRequest({
    required this.registrationNumber,
    required this.make,
    required this.model,
    required this.year,
    this.fuelType = 'petrol',
    this.isPrimary = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'registration_number': registrationNumber.toUpperCase().replaceAll(' ', ''),
      'make': make,
      'model': model,
      'year': year,
      'fuel_type': fuelType.toLowerCase(),
      'is_primary': isPrimary,
    };
  }
}
