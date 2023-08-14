import 'package:dio/dio.dart';
import 'package:speech/utils/baseApi.dart';

class AuthRepo {
  static final _client = DioClient();

  static Future<Response> socialAuth({
    required String name,
    required String email,
    required String password,
    required String photoUrl,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'photoUrl': photoUrl,
    };
    Response response = await _client.dio.post(
      "/socialAuth",
      data: data,
    );
    return response;
  }
}
