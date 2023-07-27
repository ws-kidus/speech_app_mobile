import 'package:speech/constants/constants.dart';
import 'package:dio/dio.dart';


class DioClient {
  static final DioClient _singleton = DioClient._internal();
  final baseOptions = BaseOptions(
    baseUrl: Constants.BASEAPI,
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 3),
  );
  late final Dio dio;

  factory DioClient() {
    return _singleton;
  }
  DioClient._internal() {
    dio = Dio(baseOptions);
  }
}