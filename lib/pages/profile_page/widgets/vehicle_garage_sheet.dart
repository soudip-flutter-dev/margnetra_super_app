import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/vehicle_model.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/vehicle_bloc/vehicle_bloc.dart';
import 'add_vehicle_bottom_sheet.dart';

class VehicleGarageSheet extends StatelessWidget {
  const VehicleGarageSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<VehicleBloc>(),
        child: const VehicleGarageSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF111116);
    const borderColor = Color(0xFF25252D);
    const cyan = Color(0xFF16D9E3);
    const mutedText = Color(0xFF8A8A95);

    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: const BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(top: BorderSide(color: borderColor, width: 1.5)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 4,
              decoration: BoxDecoration(
                color: borderColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vehicle Garage',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Your registered cars and motorbikes',
                    style: TextStyle(color: mutedText, fontSize: 13),
                  ),
                ],
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cyan.withAlpha(30),
                  foregroundColor: cyan,
                  elevation: 0,
                  side: const BorderSide(color: cyan, width: 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Add Vehicle', style: TextStyle(fontWeight: FontWeight.w600)),
                onPressed: () {
                  Navigator.of(context).pop();
                  AddVehicleBottomSheet.show(context);
                },
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: BlocBuilder<VehicleBloc, VehicleState>(
              builder: (context, state) {
                if (state is VehicleLoading && state.cachedVehicles == null) {
                  return const Center(child: CircularProgressIndicator(color: cyan));
                }

                final List<VehicleModel> vehicles = (state is VehicleLoaded)
                    ? state.vehicles
                    : (state is VehicleLoading)
                        ? (state.cachedVehicles ?? [])
                        : [];

                if (vehicles.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_car_outlined, size: 54, color: mutedText.withAlpha(120)),
                        const SizedBox(height: 12),
                        const Text(
                          'No vehicles added yet',
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Add your car or motorcycle to start tracking trips',
                          style: TextStyle(color: mutedText, fontSize: 13),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: vehicles.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final vehicle = vehicles[index];
                    return _buildVehicleCard(vehicle);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(VehicleModel vehicle) {
    const cardBg = Color(0xFF16161D);
    const borderColor = Color(0xFF25252D);
    const cyan = Color(0xFF16D9E3);
    const mutedText = Color(0xFF8A8A95);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: vehicle.isPrimary ? cyan.withAlpha(120) : borderColor,
          width: vehicle.isPrimary ? 1.5 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cyan.withAlpha(25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_car, color: cyan, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '${vehicle.make} ${vehicle.model}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (vehicle.isPrimary) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: cyan.withAlpha(30),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PRIMARY',
                          style: TextStyle(color: cyan, fontSize: 9, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle.registrationNumber,
                  style: const TextStyle(
                    color: Color(0xFFE2E8F0),
                    fontSize: 13,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Year ${vehicle.year}',
                      style: const TextStyle(color: mutedText, fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Container(width: 3, height: 3, color: mutedText),
                    const SizedBox(width: 8),
                    Text(
                      vehicle.fuelType.toUpperCase(),
                      style: const TextStyle(color: mutedText, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
