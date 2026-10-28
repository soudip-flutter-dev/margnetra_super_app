import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/vehicle_model.dart';

abstract class VehicleState extends Equatable {
  const VehicleState();

  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {
  const VehicleInitial();
}

class VehicleLoading extends VehicleState {
  final List<VehicleModel>? cachedVehicles;
  const VehicleLoading({this.cachedVehicles});

  @override
  List<Object?> get props => [cachedVehicles];
}

class VehicleLoaded extends VehicleState {
  final List<VehicleModel> vehicles;
  final bool isSubmitting;
  final String? submitError;

  const VehicleLoaded({
    required this.vehicles,
    this.isSubmitting = false,
    this.submitError,
  });

  VehicleLoaded copyWith({
    List<VehicleModel>? vehicles,
    bool? isSubmitting,
    String? submitError,
  }) {
    return VehicleLoaded(
      vehicles: vehicles ?? this.vehicles,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: submitError,
    );
  }

  @override
  List<Object?> get props => [vehicles, isSubmitting, submitError];
}

class VehicleAddSuccess extends VehicleState {
  final VehicleModel vehicle;
  final List<VehicleModel> vehicles;
  final String message;

  const VehicleAddSuccess({
    required this.vehicle,
    required this.vehicles,
    required this.message,
  });

  @override
  List<Object?> get props => [vehicle, vehicles, message];
}

class VehicleError extends VehicleState {
  final String message;
  final List<VehicleModel>? cachedVehicles;

  const VehicleError({required this.message, this.cachedVehicles});

  @override
  List<Object?> get props => [message, cachedVehicles];
}
