import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/pages/profile_page/data/models/profile_models.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/vehicle_bloc/vehicle_bloc.dart';

class AddVehicleBottomSheet extends StatefulWidget {
  final bool isLocked;

  const AddVehicleBottomSheet({super.key, this.isLocked = false});

  static Future<bool?> show(BuildContext context, {bool isLocked = false}) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: !isLocked,
      enableDrag: !isLocked,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<VehicleBloc>(),
        child: AddVehicleBottomSheet(isLocked: isLocked),
      ),
    );
  }

  @override
  State<AddVehicleBottomSheet> createState() => _AddVehicleBottomSheetState();
}

class _AddVehicleBottomSheetState extends State<AddVehicleBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _yearController = TextEditingController(text: DateTime.now().year.toString());
  final _chassisController = TextEditingController();

  String _selectedVehicleType = 'CAR';
  String _selectedFuelType = 'PETROL';
  bool _isPrimary = true;

  final List<String> _vehicleTypes = [
    'CAR',
    'MOTORCYCLE',
    'SCOOTER',
    'TRUCK',
    'BUS',
    'OTHER',
  ];

  final List<String> _fuelTypes = [
    'PETROL',
    'DIESEL',
    'ELECTRIC',
    'CNG',
    'HYBRID',
    'OTHER',
  ];

  @override
  void dispose() {
    _plateController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _chassisController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final request = VehicleRegistrationRequestModel(
        registrationNumber: _plateController.text.trim(),
        vehicleType: _selectedVehicleType,
        make: _makeController.text.trim(),
        model: _modelController.text.trim(),
        fuelType: _selectedFuelType,
        year: int.tryParse(_yearController.text.trim()) ?? DateTime.now().year,
        chassisNumber: _chassisController.text.trim().isNotEmpty
            ? _chassisController.text.trim()
            : null,
      );

      // Pre-save to local DB immediately
      SharedPrefService.instance.saveRegisteredVehicle(request.toJson());
      SharedPrefService.instance.setVehicleRegistered(true);

      context.read<VehicleBloc>().add(RegisterVehicleEvent(request));
    }
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF111116);
    const borderColor = Color(0xFF25252D);
    const cyan = Color(0xFF16D9E3);
    const mutedText = Color(0xFF8A8A95);

    return PopScope(
      canPop: !widget.isLocked,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        CustomSnackBar.showError(
          context,
          'Vehicle registration is required to activate the speedometer and continue.',
        );
      },
      child: BlocConsumer<VehicleBloc, VehicleState>(
        listener: (context, state) async {
          if (state is VehicleRegistrationSuccess) {
            if (state.response.data != null) {
              await SharedPrefService.instance
                  .saveRegisteredVehicle(state.response.data!.toJson());
            }
            await SharedPrefService.instance.setVehicleRegistered(true);
            if (context.mounted) {
              CustomSnackBar.showSuccess(
                context,
                state.response.message ?? 'Vehicle registered successfully',
              );
              Navigator.of(context).pop(true);
            }
          } else if (state is VehicleAddSuccess) {
            await SharedPrefService.instance
                .saveRegisteredVehicle(state.vehicle.toJson());
            await SharedPrefService.instance.setVehicleRegistered(true);
            if (context.mounted) {
              CustomSnackBar.showSuccess(context, state.message);
              Navigator.of(context).pop(true);
            }
          }
        },
        builder: (context, state) {
          final isSubmitting = state is VehicleLoaded && state.isSubmitting;
          final errorMessage = (state is VehicleLoaded) ? state.submitError : null;

          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(top: BorderSide(color: borderColor, width: 1.5)),
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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

                      // Locked Mandatory Notice
                      if (widget.isLocked) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: cyan.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: cyan.withAlpha(90)),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.lock_rounded, color: cyan, size: 20),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Register your vehicle to activate the speedometer. This step is mandatory before viewing speed data.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Register Vehicle',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          if (!widget.isLocked)
                            IconButton(
                              icon: const Icon(Icons.close, color: mutedText, size: 20),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Link your vehicle to track driving trips, active speed, and monitor e-challans',
                        style: TextStyle(color: mutedText, fontSize: 13),
                      ),
                      const SizedBox(height: 18),

                      // Inline Error Warning
                      if (errorMessage != null && errorMessage.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.red.withAlpha(25),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red.withAlpha(80)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  errorMessage,
                                  style: const TextStyle(color: Colors.redAccent, fontSize: 12.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Registration Plate Field
                      _buildTextField(
                        controller: _plateController,
                        label: 'Registration Number Plate',
                        hint: 'e.g. KA01AB1234',
                        textCapitalization: TextCapitalization.characters,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Enter vehicle registration number';
                          }
                          if (value.trim().length < 5) {
                            return 'Enter a valid registration plate';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Make & Model Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _makeController,
                              label: 'Manufacturer / Make',
                              hint: 'e.g. Maruti, Tata',
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _modelController,
                              label: 'Vehicle Model',
                              hint: 'e.g. Swift, Nexon',
                              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Vehicle Type & Fuel Type Row
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Vehicle Type',
                                  style: TextStyle(color: mutedText, fontSize: 12),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF181820),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedVehicleType,
                                      isExpanded: true,
                                      dropdownColor: const Color(0xFF181820),
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                      items: _vehicleTypes.map((type) {
                                        return DropdownMenuItem(
                                          value: type,
                                          child: Text(type),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedVehicleType = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Fuel Type',
                                  style: TextStyle(color: mutedText, fontSize: 12),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF181820),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedFuelType,
                                      isExpanded: true,
                                      dropdownColor: const Color(0xFF181820),
                                      style: const TextStyle(color: Colors.white, fontSize: 14),
                                      items: _fuelTypes.map((type) {
                                        return DropdownMenuItem(
                                          value: type,
                                          child: Text(type),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        if (val != null) setState(() => _selectedFuelType = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Year & Chassis Number Row
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: _yearController,
                              label: 'Year',
                              hint: 'e.g. 2023',
                              keyboardType: TextInputType.number,
                              validator: (v) {
                                final y = int.tryParse(v ?? '');
                                if (y == null || y < 1980 || y > DateTime.now().year + 1) {
                                  return 'Enter valid year';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: _buildTextField(
                              controller: _chassisController,
                              label: 'Chassis Number (Optional)',
                              hint: 'e.g. MAT612345N1234567',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Primary Vehicle Checkbox
                      Row(
                        children: [
                          Checkbox(
                            value: _isPrimary,
                            activeColor: cyan,
                            checkColor: Colors.black,
                            onChanged: (val) => setState(() => _isPrimary = val ?? false),
                          ),
                          const Text(
                            'Set as primary vehicle for daily driving',
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cyan,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: isSubmitting ? null : _submit,
                          child: isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                    color: Colors.black,
                                  ),
                                )
                              : Text(
                                  widget.isLocked
                                      ? 'Register & Activate Speedometer'
                                      : 'Add Vehicle',
                                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.words,
    String? Function(String?)? validator,
  }) {
    const borderColor = Color(0xFF25252D);
    const mutedText = Color(0xFF8A8A95);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: mutedText, fontSize: 12)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          validator: validator,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: mutedText.withAlpha(120), fontSize: 13),
            filled: true,
            fillColor: const Color(0xFF181820),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFF16D9E3)),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }
}
