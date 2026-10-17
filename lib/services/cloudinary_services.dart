import 'dart:io';

import 'package:dio/dio.dart';

class CloudinaryService {
  final Dio _dio = Dio();

  final String cloudName = "dnjtsesh1";
  final String uploadPreset = "texops";

  Future<String?> uploadImage(File file) async {
    try {
      String url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";

      FormData data = FormData.fromMap({
        "file": await MultipartFile.fromFile(file.path),
        "upload_preset": uploadPreset,
      });

      final response = await _dio.post(url, data: data);

      if (response.statusCode == 200) {
        return response.data["secure_url"];
      }

      return null;
    } catch (e) {
      throw Exception("Image upload failed: $e");
    }
  }
}
