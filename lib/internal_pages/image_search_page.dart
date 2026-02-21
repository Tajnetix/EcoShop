import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'image_detection_page.dart';

class ImageSearchPage extends StatefulWidget {
  const ImageSearchPage({super.key});

  @override
  State<ImageSearchPage> createState() => _ImageSearchPageState();
}

class _ImageSearchPageState extends State<ImageSearchPage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> pickFromGallery() async {
    try {
      final XFile? image =
          await _picker.pickImage(source: ImageSource.gallery);

      if (!mounted) return;

      if (image == null) {
        return; // user cancelled
      }

      final File file = File(image.path);

      if (!file.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image file not found")),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImageDetectionPage(imageFile: file),
        ),
      );
    } catch (e) {
      debugPrint("Gallery Error: $e");
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? image =
          await _picker.pickImage(source: ImageSource.camera);

      if (!mounted) return;

      if (image == null) {
        return; // user cancelled
      }

      final File file = File(image.path);

      if (!file.existsSync()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image file not found")),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImageDetectionPage(imageFile: file),
        ),
      );
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE6DD),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),

              const Text(
                "Image Search",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 40),

              _button("Take a Photo", takePhoto),
              const SizedBox(height: 20),
              _button("Upload Image", pickFromGallery),
            ],
          ),
        ),
      ),
    );
  }

  Widget _button(String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(20),
        dashPattern: const [6, 4],
        color: Colors.green,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}