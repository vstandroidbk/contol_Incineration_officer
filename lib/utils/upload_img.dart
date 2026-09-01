import 'package:flutter/material.dart';
import 'package:contol_officer_app/utils/colors.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:image_picker/image_picker.dart';

class UploadDocumentDialogImg extends StatelessWidget {
  final Function(String path) onFilePicked;

  const UploadDocumentDialogImg({super.key, required this.onFilePicked});

  /// 📸 Pick Image From Camera
  Future<void> pickFromCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? capturedImage = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (capturedImage != null) {
      onFilePicked(capturedImage.path);
      // ignore: use_build_context_synchronously
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  /// 🖼 Pick Image From Gallery
  Future<void> pickFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedImage != null) {
      onFilePicked(pickedImage.path);
      // ignore: use_build_context_synchronously
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    "Update Profile Photo",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    LucideIcons.x,
                    size: 20,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// 📸 Capture from Camera
            _optionTile(
              icon: LucideIcons.camera,
              title: "Open Camera",
              subtitle: "Capture a new photo",
              onTap: () => pickFromCamera(context),
            ),

            const SizedBox(height: 10),

            /// 🖼 From Gallery
            _optionTile(
              icon: LucideIcons.image,
              title: "Choose From Gallery",
              subtitle: "Select JPEG / PNG",
              onTap: () => pickFromGallery(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.textfieldBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: AppColors.primary),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.bodytextColor.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}