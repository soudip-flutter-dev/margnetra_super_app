import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:margnetra_super_app/core/utils/custom_snack_bar.dart';
import 'package:margnetra_super_app/pages/profile_page/logic/blocs/profile_bloc/profile_bloc.dart';

class AvatarPickerSheet extends StatelessWidget {
  const AvatarPickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: context.read<ProfileBloc>(),
        child: const AvatarPickerSheet(),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    Navigator.of(context).pop();

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null && context.mounted) {
        context.read<ProfileBloc>().add(UploadAvatarEvent(pickedFile.path));
        CustomSnackBar.showSuccess(context, 'Uploading avatar picture...');
      }
    } catch (e) {
      if (context.mounted) {
        CustomSnackBar.showError(context, 'Failed to pick image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const cardColor = Color(0xFF111116);
    const borderColor = Color(0xFF25252D);
    const cyan = Color(0xFF16D9E3);

    return Container(
      decoration: const BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: borderColor, width: 1.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: borderColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Change Profile Picture',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: cyan.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_outlined, color: cyan, size: 22),
            ),
            title: const Text('Take Photo', style: TextStyle(color: Colors.white)),
            onTap: () => _pickImage(context, ImageSource.camera),
          ),
          const Divider(color: borderColor, height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purpleAccent.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.photo_library_outlined, color: Colors.purpleAccent, size: 22),
            ),
            title: const Text('Choose from Gallery', style: TextStyle(color: Colors.white)),
            onTap: () => _pickImage(context, ImageSource.gallery),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
