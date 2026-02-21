import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class ImageDetectionPage extends StatefulWidget {
  final File imageFile; // ✅ Receive image from previous page

  const ImageDetectionPage({
    super.key,
    required this.imageFile,
  });

  @override
  State<ImageDetectionPage> createState() => _ImageDetectionPageState();
}

class _ImageDetectionPageState extends State<ImageDetectionPage> {
  String? detectedObject;
  String? detectedMaterial;
  double? confidence;

  @override
  void initState() {
    super.initState();
    detectObjectAndMaterial(widget.imageFile);
  }

  // ----------------------------
  // ML Kit Detection
  // ----------------------------
  Future<void> detectObjectAndMaterial(File imageFile) async {
    try {
      final inputImage = InputImage.fromFile(imageFile);

      final ImageLabeler labeler = ImageLabeler(
        options: ImageLabelerOptions(confidenceThreshold: 0.5),
      );

      final List<ImageLabel> labels = await labeler.processImage(inputImage);

      if (labels.isNotEmpty) {
        final topLabel = labels.first;

        setState(() {
          detectedObject = topLabel.label;
          confidence = topLabel.confidence;
          detectedMaterial = guessMaterial(topLabel.label);
        });
      }

      labeler.close();
    } catch (e) {
      print("Detection Error: $e");
    }
  }

  // ----------------------------
  // Rule-Based Material Guess
  // ----------------------------
  String guessMaterial(String label) {
    final lowerLabel = label.toLowerCase();

    if (lowerLabel.contains('bottle') ||
        lowerLabel.contains('container') ||
        lowerLabel.contains('cup') ||
        lowerLabel.contains('pot') ||
        lowerLabel.contains('plant')) {
      return "Plastic";
    }

    return "Unknown";
  }

  // ----------------------------
  // UI
  // ----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Eco Object Detection"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Image Preview
            Image.file(
              widget.imageFile,
              height: 220,
            ),

            const SizedBox(height: 25),

            /// Detection Result
            detectedObject != null
                ? Column(
                    children: [
                      Text(
                        "Object: $detectedObject",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Material: $detectedMaterial",
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Confidence: ${confidence != null ? (confidence! * 100).toStringAsFixed(2) + '%' : 'Calculating...'}",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  )
                : const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }
}