import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../config.dart';

class ImageUploadService {
  static const maxBytes = 5 * 1024 * 1024; // 5 MB

  /// Uploads the image to Cloudinary and returns its https URL.
  Future<String> upload(XFile file) async {
    final bytes = await file.readAsBytes();
    if (bytes.length > maxBytes) {
      throw Exception('Image is larger than 5 MB.');
    }

    final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/$kCloudinaryCloudName/image/upload');
    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = kCloudinaryPreset
      ..files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: file.name));

    final streamed = await request.send().timeout(const Duration(seconds: 30));
    final res = await http.Response.fromStream(streamed);

    if (res.statusCode != 200) {
      throw Exception('Upload failed (${res.statusCode}).');
    }
    return jsonDecode(res.body)['secure_url'] as String;
  }
}