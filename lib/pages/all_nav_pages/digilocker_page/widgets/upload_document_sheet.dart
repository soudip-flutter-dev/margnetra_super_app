import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:margnetra_super_app/core/app_services/local_storage/shared_pref_service.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/data/models/models.dart';
import 'package:margnetra_super_app/pages/all_nav_pages/digilocker_page/logic/blocs/document_bloc/document_bloc.dart';

class UploadDocumentSheet extends StatefulWidget {
  final ImagePicker? imagePicker;

  const UploadDocumentSheet({
    super.key,
    this.imagePicker,
  });

  static Future<void> show(BuildContext context, {ImagePicker? imagePicker}) {
    final bloc = context.read<DocumentBloc>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F121C),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: bloc,
          child: UploadDocumentSheet(imagePicker: imagePicker),
        );
      },
    );
  }

  @override
  State<UploadDocumentSheet> createState() => _UploadDocumentSheetState();
}

class _UploadDocumentSheetState extends State<UploadDocumentSheet> {
  static const Color _cardColor = Color(0xFF141724);
  static const Color _inputFill = Color(0xFF1A1E2E);
  static const Color _cardBorder = Color(0xFF262B3D);
  static const Color _cyan = Color(0xFF00D9E8);
  static const Color _cyanDark = Color(0xFF00AFC0);
  static const Color _white = Color(0xFFF5F7FA);
  static const Color _mutedText = Color(0xFF858A96);

  late final ImagePicker _picker;
  XFile? _selectedFile;
  bool _isPicking = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _documentNumberController =
      TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  final List<String> _documentTypes = ['PUCC', 'RC', 'INSURANCE', 'DL'];
  late String _selectedType;

  @override
  void initState() {
    super.initState();
    _picker = widget.imagePicker ?? ImagePicker();
    _selectedType = _documentTypes.first;

    // Default expiry date: 6 months from now
    final defaultExpiry = DateTime.now().add(const Duration(days: 180));
    _expiryDateController.text = _formatDate(defaultExpiry);
  }

  @override
  void dispose() {
    _documentNumberController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() => _isPicking = true);
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );

      if (picked != null) {
        setState(() {
          _selectedFile = picked;
          // Suggest a default document number if empty based on type
          if (_documentNumberController.text.trim().isEmpty) {
            final suffix = DateTime.now().millisecondsSinceEpoch % 1000000;
            _documentNumberController.text = '$_selectedType-MH12-$suffix';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, 'Failed to pick image: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isPicking = false);
      }
    }
  }

  Future<void> _selectExpiryDate() async {
    final now = DateTime.now();
    final initialDate =
        DateTime.tryParse(_expiryDateController.text) ?? now.add(const Duration(days: 180));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(now) ? initialDate : now,
      firstDate: now,
      lastDate: DateTime(now.year + 20),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: _cyan,
              onPrimary: Colors.black,
              surface: Color(0xFF141724),
              onSurface: _white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF0F121C),
            ),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _expiryDateController.text = _formatDate(picked);
      });
    }
  }

  String _getVehicleId() {
    final registeredVehicle = SharedPrefService.instance.getRegisteredVehicle();
    final vid = registeredVehicle?['id']?.toString();
    if (vid != null && vid.isNotEmpty) {
      return vid;
    }
    return '3fa85f64-5717-4562-b3fc-2c963f66afa6';
  }

  void _submitUpload() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final vehicleId = _getVehicleId();
    final docNumber = _documentNumberController.text.trim();
    final expiry = _expiryDateController.text.trim();

    // Construct CDN URL or fallback url as required by the backend schema
    final fileName = _selectedFile != null
        ? _selectedFile!.name.replaceAll(' ', '_')
        : '${_selectedType.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final fileUrl = 'https://cdn.margentra.com/docs/$fileName';

    final request = VehicleDocumentUploadRequestModel(
      vehicleId: vehicleId,
      documentType: _selectedType,
      documentNumber: docNumber,
      expiryDate: expiry,
      fileUrl: fileUrl,
    );

    final currentContext = context;

    context.read<DocumentBloc>().add(
          UploadVehicleDocumentEvent(
            request: request,
            onSuccess: (uploadedDoc) {
              if (mounted) {
                Navigator.of(currentContext).pop();
                CustomSnackBar.showSuccess(
                  currentContext,
                  '${uploadedDoc.title.isNotEmpty ? uploadedDoc.title : _selectedType} uploaded successfully',
                );
              }
            },
            onError: (error) {
              if (mounted) {
                CustomSnackBar.showError(currentContext, error);
              }
            },
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;

    return BlocBuilder<DocumentBloc, DocumentState>(
      builder: (context, state) {
        final isUploading = state is DocumentLoaded && state.isUploading;

        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: bottomInset > 0 ? bottomInset + 16 : 28,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 42,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _cardBorder,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Upload or Scan Document',
                        style: TextStyle(
                          color: _white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      IconButton(
                        onPressed: isUploading ? null : () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: _mutedText, size: 20),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Capture via device camera or choose a file from your device to register.',
                    style: TextStyle(color: _mutedText, fontSize: 13),
                  ),
                  const SizedBox(height: 20),

                  // -------------------------------------------------------------
                  // Camera / File Source Selector
                  // -------------------------------------------------------------
                  Row(
                    children: [
                      Expanded(
                        child: _buildSourceOptionCard(
                          icon: Icons.camera_alt_rounded,
                          title: 'Camera',
                          subtitle: 'Scan document',
                          color: _cyan,
                          onTap: isUploading || _isPicking
                              ? null
                              : () => _pickImage(ImageSource.camera),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildSourceOptionCard(
                          icon: Icons.file_upload_outlined,
                          title: 'Device File',
                          subtitle: 'Upload photo/file',
                          color: const Color(0xFF4CA8FF),
                          onTap: isUploading || _isPicking
                              ? null
                              : () => _pickImage(ImageSource.gallery),
                        ),
                      ),
                    ],
                  ),

                  // Selected image preview (if picked)
                  if (_selectedFile != null) ...[
                    const SizedBox(height: 16),
                    _buildFilePreviewCard(),
                  ],

                  const SizedBox(height: 20),

                  // -------------------------------------------------------------
                  // Document Type Selector Chips
                  // -------------------------------------------------------------
                  const Text(
                    'DOCUMENT TYPE',
                    style: TextStyle(
                      color: _mutedText,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _documentTypes.map((type) {
                      final isSelected = _selectedType == type;
                      return ChoiceChip(
                        label: Text(type),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.black : _white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                        selected: isSelected,
                        selectedColor: _cyan,
                        backgroundColor: _inputFill,
                        side: BorderSide(
                          color: isSelected ? _cyan : _cardBorder,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedType = type;
                              // Update document number prefix suggestion
                              if (_documentNumberController.text.contains('-MH12-')) {
                                final parts = _documentNumberController.text.split('-MH12-');
                                _documentNumberController.text = '$type-MH12-${parts.last}';
                              }
                            });
                          }
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 18),

                  // -------------------------------------------------------------
                  // Document Number Input Field
                  // -------------------------------------------------------------
                  const Text(
                    'DOCUMENT NUMBER',
                    style: TextStyle(
                      color: _mutedText,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _documentNumberController,
                    style: const TextStyle(color: _white, fontSize: 14),
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'e.g. PUCC-MH12-987654',
                      hintStyle: const TextStyle(color: Color(0xFF555B6E), fontSize: 13),
                      filled: true,
                      fillColor: _inputFill,
                      prefixIcon: const Icon(Icons.badge_outlined, color: _cyan, size: 20),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _cardBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _cardBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: _cyan, width: 1.5),
                      ),
                    ),
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Please enter document number';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  // -------------------------------------------------------------
                  // Expiry Date Field
                  // -------------------------------------------------------------
                  const Text(
                    'EXPIRY DATE',
                    style: TextStyle(
                      color: _mutedText,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectExpiryDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _expiryDateController,
                        style: const TextStyle(color: _white, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'YYYY-MM-DD',
                          hintStyle:
                              const TextStyle(color: Color(0xFF555B6E), fontSize: 13),
                          filled: true,
                          fillColor: _inputFill,
                          prefixIcon: const Icon(Icons.calendar_today_outlined,
                              color: _cyan, size: 19),
                          suffixIcon: const Icon(Icons.arrow_drop_down,
                              color: _mutedText, size: 22),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _cardBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _cardBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: _cyan, width: 1.5),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return 'Please select expiry date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // -------------------------------------------------------------
                  // Submit / Upload Button
                  // -------------------------------------------------------------
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: isUploading
                              ? [_cardBorder, _cardBorder]
                              : [_cyanDark, _cyan],
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: isUploading
                            ? []
                            : [
                                BoxShadow(
                                  color: _cyan.withValues(alpha: 0.22),
                                  blurRadius: 18,
                                  offset: const Offset(0, 7),
                                ),
                              ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: isUploading ? null : _submitUpload,
                          child: Center(
                            child: isUploading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      valueColor:
                                          AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'SUBMIT / UPLOAD',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 0.8,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSourceOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _cardBorder),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: _white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: _mutedText,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilePreviewCard() {
    final fileName = _selectedFile?.name ?? 'document.jpg';
    final filePath = _selectedFile?.path;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _cyan.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 48,
              height: 48,
              color: _inputFill,
              child: filePath != null && !kIsWeb
                  ? Image.file(
                      File(filePath),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(
                        Icons.description_outlined,
                        color: _cyan,
                        size: 26,
                      ),
                    )
                  : const Icon(
                      Icons.description_outlined,
                      color: _cyan,
                      size: 26,
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Selected File',
                  style: TextStyle(
                    color: _cyan,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  fileName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedFile = null;
              });
            },
            icon: const Icon(Icons.close, color: _mutedText, size: 18),
            tooltip: 'Remove',
          ),
        ],
      ),
    );
  }
}
