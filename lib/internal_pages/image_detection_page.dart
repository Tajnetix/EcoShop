import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'vision_service.dart';

class ImageDetectionPage extends StatefulWidget {
  final File? imageFile;
  final Uint8List? imageBytes;

  const ImageDetectionPage({
    super.key,
    this.imageFile,
    this.imageBytes,
  });

  @override
  State<ImageDetectionPage> createState() =>
      _ImageDetectionPageState();
}

class _ImageDetectionPageState
    extends State<ImageDetectionPage> {
  List<String> labels = [];
  bool isLoading = true;

  final ImageLabeler _imageLabeler =
      ImageLabeler(options: ImageLabelerOptions(confidenceThreshold: 0.5));

  @override
  void initState() {
    super.initState();
    detect();
  }

  Future<void> detect() async {
    try {
      if (kIsWeb) {
        // 🌐 WEB → Google Vision API
        final result =
            await VisionService.detectLabels(widget.imageBytes!);
        labels = result;
      } else {
        // 📱 MOBILE → ML Kit
        final inputImage =
            InputImage.fromFile(widget.imageFile!);

        final recognizedLabels =
            await _imageLabeler.processImage(inputImage);

        labels = recognizedLabels
            .map((e) =>
                "${e.label} (${(e.confidence * 100).toStringAsFixed(1)}%)")
            .toList();
      }
    } catch (e) {
      debugPrint("Detection Error: $e");
    }

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _imageLabeler.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Image Detection")),
      body: Column(
        children: [
          Expanded(
            child: kIsWeb
                ? Image.memory(widget.imageBytes!,
                    fit: BoxFit.cover)
                : Image.file(widget.imageFile!,
                    fit: BoxFit.cover),
          ),
          isLoading
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