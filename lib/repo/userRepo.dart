import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:speech/utils/baseApi.dart';
import 'package:speech/utils/utils.dart';
import 'package:http_parser/http_parser.dart';

class UserRepo {
  static final _client = DioClient();

  static Future<Response> fetchUser({
    required Options options,
  }) async {
    Response response = await _client.dio.get(
      "/user",
      options: options,
    );
    return response;
  }

  static Future<bool> changeBackgroundImage({
    required Options options,
    required XFile image,
  }) async {
    FormData formData = FormData();
    final compressedImage = await Utils.compressImage(image.path);
    String imageName = image.path.split('/').last;
    formData.files.add(
      MapEntry(
        "image",
        MultipartFile.fromBytes(
          compressedImage,
          contentType: MediaType('image', 'jpeg'),
          filename: imageName,
        ),
      ),
    );

    Response response = await _client.dio.post(
      "/user/changeBackgroundImage",
      options: options,
      data: formData,
    );
    return response.statusCode ==200;
  }

  static Future<bool> changeProfileImage({
    required Options options,
    required XFile image,
  }) async {
    FormData formData = FormData();
    final compressedImage = await Utils.compressImage(image.path);
    String imageName = image.path.split('/').last;
    formData.files.add(
      MapEntry(
        "image",
        MultipartFile.fromBytes(
          compressedImage,
          contentType: MediaType('image', 'jpeg'),
          filename: imageName,
        ),
      ),
    );

    Response response = await _client.dio.post(
      "/user/changeProfileImage",
      options: options,
      data: formData,
    );
    return response.statusCode ==200;
  }

  static Future<bool> updateUserDetails({
    required Options options,
    String? name,
    String?phone,
  }) async {
    final data = {
      "name":name,
      "phone":phone,
    };

    Response response = await _client.dio.put(
      "/user/updateUserDetails",
      options: options,
      data: data,
    );
    return response.statusCode ==200;
  }
}
