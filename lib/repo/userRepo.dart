import 'package:dio/dio.dart';
import 'package:speech/utils/baseApi.dart';

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
}
