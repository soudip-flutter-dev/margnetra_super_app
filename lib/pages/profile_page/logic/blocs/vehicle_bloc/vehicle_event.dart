import 'package:equatable/equatable.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/vehicle_model.dart';

abstract class VehicleEvent extends Equatable {
  const VehicleEvent();

  @override
  List<Object?> get props => [];
}

class LoadVehiclesEvent extends VehicleEvent {
  final bool forceRefresh;
  const LoadVehiclesEvent({this.forceRefresh = false});

  @override
  List<Object?> get props => [forceRefresh];
}

class AddVehicleEvent extends VehicleEvent {
  final VehicleCreateRequest request;
  const AddVehicleEvent(this.request);

  @override
  List<Object?> get props => [request];
}
