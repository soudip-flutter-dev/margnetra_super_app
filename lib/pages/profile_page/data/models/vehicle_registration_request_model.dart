class VehicleRegistrationRequestModel {
  final String registrationNumber;
  final String vehicleType;
  final String make;
  final String model;
  final String fuelType;
  final int year;
  final String? chassisNumber;

  VehicleRegistrationRequestModel({
    required this.registrationNumber,
    required this.vehicleType,
    required this.make,
    required this.model,
    required this.fuelType,
    required this.year,
    this.chassisNumber,
  });

  factory VehicleRegistrationRequestModel.fromJson(Map<String, dynamic> json) {
    return VehicleRegistrationRequestModel(
      registrationNumber: json['registrationNumber']?.toString() ??
          json['registration_number']?.toString() ??
          '',
      vehicleType: json['vehicleType']?.toString() ??
          json['vehicle_type']?.toString() ??
          'CAR',
      make: json['make']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      fuelType: json['fuelType']?.toString() ??
          json['fuel_type']?.toString() ??
          'PETROL',
      year: json['year'] is int
          ? json['year'] as int
          : int.tryParse(json['year']?.toString() ?? '2023') ?? 2023,
      chassisNumber: json['chassisNumber']?.toString() ??
          json['chassis_number']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'registrationNumber': registrationNumber.toUpperCase().replaceAll(' ', ''),
      'vehicleType': vehicleType.toUpperCase(),
      'make': make.trim(),
      'model': model.trim(),
      'fuelType': fuelType.toUpperCase(),
      'year': year,
    };
    if (chassisNumber != null && chassisNumber!.trim().isNotEmpty) {
      map['chassisNumber'] = chassisNumber!.trim().toUpperCase();
    }
    return map;
  }
}

