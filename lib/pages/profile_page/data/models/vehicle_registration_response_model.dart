import 'vehicle_model.dart';

class VehicleRegistrationResponseModel {
  final bool? success;
  final String? message;
  final VehicleRegistrationData? data;

  VehicleRegistrationResponseModel({
    this.success,
    this.message,
    this.data,
  });

  factory VehicleRegistrationResponseModel.fromJson(Map<String, dynamic> json) {
    return VehicleRegistrationResponseModel(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? VehicleRegistrationData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class VehicleRegistrationData {
  final String? id;
  final String? registrationNumber;
  final String? vehicleType;
  final String? make;
  final String? model;
  final String? fuelType;
  final int? year;
  final String? chassisNumber;
  final String? createdAt;
  final String? updatedAt;
  final bool? active;
  final bool? selected;

  VehicleRegistrationData({
    this.id,
    this.registrationNumber,
    this.vehicleType,
    this.make,
    this.model,
    this.fuelType,
    this.year,
    this.chassisNumber,
    this.createdAt,
    this.updatedAt,
    this.active,
    this.selected,
  });

  factory VehicleRegistrationData.fromJson(Map<String, dynamic> json) {
    return VehicleRegistrationData(
      id: json['id']?.toString(),
      registrationNumber: json['registrationNumber']?.toString() ??
          json['registration_number']?.toString(),
      vehicleType: json['vehicleType']?.toString() ??
          json['vehicle_type']?.toString(),
      make: json['make']?.toString(),
      model: json['model']?.toString(),
      fuelType: json['fuelType']?.toString() ??
          json['fuel_type']?.toString(),
      year: json['year'] is int
          ? json['year'] as int
          : int.tryParse(json['year']?.toString() ?? ''),
      chassisNumber: json['chassisNumber']?.toString() ??
          json['chassis_number']?.toString(),
      createdAt: json['createdAt']?.toString() ??
          json['created_at']?.toString(),
      updatedAt: json['updatedAt']?.toString() ??
          json['updated_at']?.toString(),
      active: json['active'] as bool?,
      selected: (json['selected'] ?? json['isPrimary'] ?? json['is_primary']) as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'registrationNumber': registrationNumber,
      'vehicleType': vehicleType,
      'make': make,
      'model': model,
      'fuelType': fuelType,
      'year': year,
      if (chassisNumber != null) 'chassisNumber': chassisNumber,
      if (createdAt != null) 'createdAt': createdAt,
      if (updatedAt != null) 'updatedAt': updatedAt,
      if (active != null) 'active': active,
      if (selected != null) 'selected': selected,
    };
  }

  VehicleModel toVehicleModel() {
    return VehicleModel(
      id: id ?? '',
      registrationNumber: registrationNumber ?? '',
      make: make ?? '',
      model: model ?? '',
      vehicleType: vehicleType ?? 'CAR',
      fuelType: fuelType ?? 'PETROL',
      year: year ?? DateTime.now().year,
      chassisNumber: chassisNumber,
      isPrimary: selected ?? false,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
    );
  }
}

