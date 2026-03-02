import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageDetectionPageWeb extends StatelessWidget {
  final Uint8List imageBytes;

  const ImageDetectionPageWeb({super.key, required this.imageBytes});

  @override
  Widget build(BuildContext context) {
    // Fake labels for UI consistency
    final List<String> fakeLabels = [
      "Example Label 1 (95.0%)",
      "Example Label 2 (88.5%)",
      "Example Label 3 (76.2%)",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Image Detection (Web)")),
      body: Column(
        children: [
          Expanded(
            child: Image.memory(imageBytes,
                fit: BoxFit.cover, width: double.infinity),
          ),
          const SizedBox(height: 16),
          const Text(
            "ML Kit not supported on Web",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: fakeLabels.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.label),
                  title: Text(fakeLabels[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}