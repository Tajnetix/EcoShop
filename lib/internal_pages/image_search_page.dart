import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'image_detection_page.dart';

class ImageSearchPage extends StatefulWidget {
  const ImageSearchPage({super.key});

  @override
  State<ImageSearchPage> createState() => _ImageSearchPageState();
}

class _ImageSearchPageState extends State<ImageSearchPage> {
  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  Future<void> pickFromGallery() async {
    try {
      debugPrint("Gallery button tapped");

      final XFile? image =
          await _picker.pickImage(source: ImageSource.gallery);

      if (!mounted || image == null) {
        debugPrint("No image selected or widget not mounted");
        return;
      }

      if (kIsWeb) {
        final Uint8List bytes = await image.readAsBytes();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ImageDetectionPage(imageBytes: bytes),
          ),
        );
      } else {
        final file = File(image.path);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ImageDetectionPage(imageFile: file),
          ),
        );
      }
    } catch (e) {
      debugPrint("Gallery Error: $e");
    }
  }

  /// Take photo with camera
  Future<void> takePhoto() async {
    try {
      debugPrint("Camera button tapped");

      final XFile? image =
          await _picker.pickImage(source: ImageSource.camera);

      if (!mounted || image == null) return;

      if (kIsWeb) {
        final Uint8List bytes = await image.readAsBytes();

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ImageDetectionPage(imageBytes: bytes),
          ),
        );
      } else {
        final file = File(image.path);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ImageDetectionPage(imageFile: file),
          ),
        );
      }
    } catch (e) {
      debugPrint("Camera Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE6DD),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double screenWidth = constraints.maxWidth;
            double horizontalPadding = screenWidth * 0.04;
            double cardWidth = screenWidth - 2 * horizontalPadding;
            const double spacing = 25;

            return SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              "Image Search",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const SizedBox(height: 30),

                    /// Search by Image Card
                    _normalCard(
                      width: cardWidth,
                      background: const Color(0xFFB7D6B7),
                      child: Row(
                        children: const [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            radius: 22,
                            child: Icon(Icons.search,
                                color: Color(0xFF2E7D32)),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Search by Image",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.w600),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  "Find sustainable alternatives instantly",
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: spacing),

                    /// Take Photo
                    _dottedCard(
                      width: cardWidth,
                      icon: Icons.camera_alt_outlined,
                      title: "Take a Photo",
                      subtitle:
                          "Use your camera to scan a product",
                      onTap: takePhoto,
                    ),
                    SizedBox(height: spacing),

                    /// Upload Image
                    _dottedCard(
                      width: cardWidth,
                      icon: Icons.upload_outlined,
                      title: "Upload Image",
                      subtitle:
                          "Choose from your gallery",
                      onTap: pickFromGallery,
                    ),
                    SizedBox(height: spacing),

                    /// How it works
                    _normalCard(
                      width: cardWidth,
                      background: const Color(0xFFB7D6B7)
                          .withOpacity(0.7),
                      child: const Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              "How it works",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight:
                                      FontWeight.w600),
                            ),
                            SizedBox(height: 12),
                            Text(
                                "1. Take a photo or upload an image of a product"),
                            SizedBox(height: 6),
                            Text(
                                "2. Our AI analyzes the image"),
                            SizedBox(height: 6),
                            Text(
                                "3. Get sustainable alternatives instantly"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Solid Card
  Widget _normalCard({
    required double width,
    required Color background,
    Widget? child,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }

  /// Dotted Card
  Widget _dottedCard({
    required double width,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(24),
        color: const Color(0xFF8FBF8F),
        strokeWidth: 1.5,
        dashPattern: const [6, 4],
        child: Container(
          width: width,
          padding: const EdgeInsets.symmetric(
              vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              Container(
                height: width * 0.12,
                width: width * 0.12,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFD9EED9),
                ),
                child: Icon(icon,
                    color: const Color(0xFF2E7D32)),
              ),
              const SizedBox(height: 12),
              Text(title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text(subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }
}