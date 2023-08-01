import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class Utils {
  static Future<List<int>> compressImage(String path) async {
    List<int>? result;
    try {
      result = await FlutterImageCompress.compressWithFile(path,
          format: CompressFormat.jpeg, quality: 75);
    } on Error catch (e) {
      debugPrint("ERROR ON COMPRESSING IMAGE");
      debugPrint(e.toString());
      debugPrint(e.stackTrace.toString());
    } on Exception catch (e) {
      debugPrint("ERROR ON COMPRESSING IMAGE");
      debugPrint(e.toString());
    }
    return result ?? [];
  }
}
