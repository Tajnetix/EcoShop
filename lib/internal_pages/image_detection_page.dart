import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';

class ImageDetectionPage extends StatefulWidget {
  final File imageFile;

  const ImageDetectionPage({super.key, required this.imageFile});

  @override
  State<ImageDetectionPage> createState() => _ImageDetectionPageState();
}

class _ImageDetectionPageState extends State<ImageDetectionPage> {
  final ImageLabeler _imageLabeler =
      ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));
  List<String> labels = [];
  bool isProcessing = true;

  @override
  void initState() {
    super.initState();
    _processImage();
  }

  Future<void> _processImage() async {
    setState(() {
      isProcessing = true;
    });

    final inputImage = InputImage.fromFile(widget.imageFile);

    try {
      final recognizedLabels = await _imageLabeler.processImage(inputImage);

      labels = recognizedLabels
          .map((e) =>
              "${e.label} (${(e.confidence * 100).toStringAsFixed(1)}%)")
          .toList();

      debugPrint("Labels detected: $labels");
    } catch (e) {
      debugPrint("ML Kit Error: $e");
    }

    if (mounted) {
      setState(() {
        isProcessing = false;
      });
    }
  }

  @override
  void dispose() {
    _imageLabeler.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Detection")),
      body: Column(
        children: [
          Expanded(
            child: Image.file(widget.imageFile,
                fit: BoxFit.cover, width: double.infinity),
          ),
          isProcessing
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: labels.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.label),
                        title: Text(labels[index]),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}