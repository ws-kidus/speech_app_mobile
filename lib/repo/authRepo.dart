import 'package:dio/dio.dart';
import 'package:speech/utils/baseApi.dart';

class AuthRepo {
  static final _client = DioClient();

  static Future<Response> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final data = {
      'name':name,
      'email': email,
      'password': password,
    };

    final options = Options(
      headers: {"Accept": "application/json"},
    );

    Response response = await _client.dio.post(
      "/signUp",
      data: data,
      options: options,
    );
    return response;
  }

  static Future<Response> signIn({
    required String email,
    required String password,
  }) async {
    final data = {
      'email': email,
      'password': password,
    };

    final options = Options(
      headers: {"Accept": "application/json"},
    );

    Response response = await _client.dio.post(
      "/signIn",
      data: data,
      options: options,
    );
    return response;
  }

  static Future<Response> socialAuth({
    required String name,
    required String email,
    required String password,
    required String? photoUrl,
    required int type,
  }) async {
    final data = {
      'name': name,
      'email': email,
      'password': password,
      'photoUrl': photoUrl,
      'type': type,
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
