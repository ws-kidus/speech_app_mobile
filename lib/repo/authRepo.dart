import 'package:dio/dio.dart';
import 'package:speech/utils/baseApi.dart';

class AuthRepo {
  static final _client = DioClient();

  static Future<Response> socialAuth({
    required String name,
    required String email,
    required String password,
    required String? photoUrl,
    required int type
  }) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'photoUrl': photoUrl,
      'type':type,
    };

    final options = Options(
      headers: {"Accept": "application/json"},
    );

    Response response = await _client.dio.post(
      "/socialAuth",
      data: data,
      options: options,
    );
    return response;
  }
}
