import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppImagePicker extends StatelessWidget {
  final File? image;
  final ValueChanged<File> onImageSelected;

  const AppImagePicker({
    super.key,
    required this.image,
    required this.onImageSelected,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Camera"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Gallery"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      onImageSelected(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (image != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              image!,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _pickImage(context),
          icon: const Icon(Icons.upload),
          label: const Text("Upload Image"),
        ),
      ],
    );
  }
}
