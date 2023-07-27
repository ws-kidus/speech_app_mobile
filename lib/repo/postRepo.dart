import 'package:dio/dio.dart';
import 'package:speech/utils/baseApi.dart';

class PostRepo {
  static final _client = DioClient();

  static Future<Response> fetchPosts({
    required int page,
  }) async {
    Response response = await _client.dio.get(
      "/posts",
      queryParameters: {
        "page": page,
      },
    );
    return response;
  }
}
