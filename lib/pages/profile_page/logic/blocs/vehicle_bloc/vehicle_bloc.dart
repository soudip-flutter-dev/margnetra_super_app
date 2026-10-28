import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_exception_handler/app_exception_handler.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/vehicle_model.dart';
import 'package:margnetra_super_app/pages/profile_page/data/repositories/user_repository.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

export 'vehicle_event.dart';
export 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  final IUserRepository _userRepository;

  VehicleBloc({required IUserRepository userRepository})
      : _userRepository = userRepository,
        super(const VehicleInitial()) {
    on<LoadVehiclesEvent>(_onLoadVehicles);
    on<AddVehicleEvent>(_onAddVehicle);
  }

  Future<void> _onLoadVehicles(
    LoadVehiclesEvent event,
    Emitter<VehicleState> emit,
  ) async {
    final cached = _userRepository.getCachedVehicles();
    if (cached != null && !event.forceRefresh) {
      emit(VehicleLoaded(vehicles: cached));
    } else {
      emit(VehicleLoading(cachedVehicles: cached));
    }

    try {
      final vehicles = await _userRepository.getVehicles();
      emit(VehicleLoaded(vehicles: vehicles));
    } catch (e) {
      final message = e is AppExceptionHandler ? e.exMsg : e.toString();
      emit(VehicleError(message: message, cachedVehicles: cached));
    }
  }

  Future<void> _onAddVehicle(
    AddVehicleEvent event,
    Emitter<VehicleState> emit,
  ) async {
    final currentState = state;
    List<VehicleModel> currentList = [];
    if (currentState is VehicleLoaded) {
      currentList = currentState.vehicles;
      emit(currentState.copyWith(isSubmitting: true, submitError: null));
    }

    try {
      final newVehicle = await _userRepository.addVehicle(event.request);
      final updatedList = List<VehicleModel>.from(currentList)..add(newVehicle);

      emit(VehicleAddSuccess(
        vehicle: newVehicle,
        vehicles: updatedList,
        message: 'Vehicle registered successfully',
      ));

      // Transition back to loaded state with updated list
      emit(VehicleLoaded(vehicles: updatedList));
    } catch (e) {
      final message = e is AppExceptionHandler ? e.exMsg : e.toString();
      if (currentState is VehicleLoaded) {
        emit(currentState.copyWith(isSubmitting: false, submitError: message));
      } else {
        emit(VehicleLoaded(vehicles: currentList, submitError: message));
      }
    }
  }
}
