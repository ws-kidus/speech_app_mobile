import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech/provider/uploadImageProvider.dart';

class UploadImageService extends StateNotifier<UploadImageState> {
  final Ref ref;
  late ImagePicker picker;

  UploadImageService({required this.ref})
      : super(UploadImageState(images: [])) {
    picker = ImagePicker();
  }

  List<XFile> _images = [];
  
  Future getImage(UploadSource source) async {
    switch (source) {
      case UploadSource.CAMERA:
        final img = await picker.pickImage(source: ImageSource.camera);
        if (img != null) {
          _images.add(img);
        }
        break;
      case UploadSource.GALLERY:
        final img = await picker.pickImage(source: ImageSource.gallery);
        if (img != null) {
          _images.add(img);
        }
        break;
      case UploadSource.MULTIPLE:
        final img = await picker.pickMultiImage();
        if (img.isNotEmpty) {

          img.map((e){
            if(_images.length < 4){
              _images.add(e);
            }else{
              return;
            }
          }).toList();

        }
        break;
    }

    state = state.copyWith(images: _images);
  }

  remove() {
    _images = [];
    state = state.copyWith(images: _images);
  }

  removeWhere(int index){
    final images = state.images;
    images.removeAt(index);
    state = state.copyWith(images: images);  }
}
