
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech/service/uploadImageService.dart';

enum UploadSource{
  GALLERY,
  CAMERA,
  MULTIPLE,
}

class UploadImageState {
  final List<XFile> images;

  UploadImageState({
    required this.images,
  });

  UploadImageState copyWith({
    List<XFile>? images,
  }) {
    return UploadImageState(
      images: images ?? this.images,
    );
  }
}

final uploadImageStateProvider =
    StateNotifierProvider<UploadImageService, UploadImageState>((ref) {
  return UploadImageService(ref: ref);
});
