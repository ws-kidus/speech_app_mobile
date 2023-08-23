import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech/utils/baseApi.dart';
import 'package:speech/utils/utils.dart';
import 'package:http_parser/http_parser.dart';

class PostRepo {
  static final _client = DioClient();

  static Future<Response> fetchPosts({
    required Options options,
    required int page,
  }) async {
    Response response = await _client.dio.get(
      "/posts",
      // queryParameters: {"page": page},
      options: options,
    );
    return response;
  }

  static Future<bool> createPost({
    required Options options,
    required String speech,
    required List<XFile> images,
  }) async {
    FormData formData = FormData();

    formData.fields.add(MapEntry("speech", speech));

    List compressedImages = [];
    for (XFile image in images) {
      final arr = await Utils.compressImage(image.path);
      compressedImages.add(arr);
    }

    int count = 0;
    images.map((e) async {
      final image = e;
      String imageName = image.path.split('/').last;
      formData.files.add(
        MapEntry(
            "images[$count]",
            MultipartFile.fromBytes(
              compressedImages[count],
              contentType: MediaType('image', 'jpeg'),
              filename: imageName,
            )),
      );
      count++;
    }).toList();

    final response = await _client.dio.post(
      "/c_mobile_app/create_ticket",
      options: options,
      data: formData,
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateLikeStatus({
    required Options options,
    required String postId,
    required bool liked,
  }) async {
    final data = {
      'postId': postId,
      'liked': liked,
    };

    Response response = await _client.dio.post(
      "/posts/updateLike",
      options: options,
      data: data,
    );
    return response.statusCode == 200;
  }
}
