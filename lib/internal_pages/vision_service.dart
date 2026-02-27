import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class VisionService {
  static const String apiKey = "AIzaSyBnNx6g-GVRoadt9m99weHjPXgQej6xplI";

  static Future<List<String>> detectLabels(Uint8List imageBytes) async {
    final String base64Image = base64Encode(imageBytes);

    final response = await http.post(
      Uri.parse(
          "https://vision.googleapis.com/v1/images:annotate?key=$apiKey"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "requests": [
          {
            "image": {"content": base64Image},
            "features": [
              {"type": "LABEL_DETECTION", "maxResults": 5}
            ]
          }
        ]
      }),
    );

    final data = jsonDecode(response.body);

    final labels = data["responses"][0]["labelAnnotations"];

    return labels
        .map<String>((label) =>
            "${label["description"]} (${(label["score"] * 100).toStringAsFixed(1)}%)")
        .toList();
  }
}