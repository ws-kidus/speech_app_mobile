import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech/provider/uploadImageProvider.dart';

class UploadImage extends ConsumerWidget {
  final double height;
  final bool isMultipleImage;

  const UploadImage({
    Key? key,
    this.height = 180,
    this.isMultipleImage = false,
  }) : super(key: key);

  void _uploadImage({
    required WidgetRef ref,
    required UploadSource source,
  }) {
    ref.read(uploadImageStateProvider.notifier).getImage(source);
  }

  Widget _button({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
  }) {
    return TextButton(
        onPressed: onPressed,
        child: Text(text,
            style: Theme.of(context)
                .textTheme
                .button!
                .copyWith(decoration: TextDecoration.underline)));
  }

  Widget _selectOneImage({
    required BuildContext context,
    required WidgetRef ref,
    required List<XFile> images,
    bool fromMultipleSelect = false,
  }) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: images.isNotEmpty
          ? Image.file(
              File(images.first.path),
              fit: BoxFit.cover,
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _button(
                  context: context,
                  onPressed: () => _uploadImage(
                    ref: ref,
                    source: fromMultipleSelect
                        ? UploadSource.MULTIPLE
                        : UploadSource.GALLERY,
                  ),
                  text: "choose form gallery",
                ),
                const SizedBox(height: 5),
                _button(
                  context: context,
                  onPressed: () => _uploadImage(
                    ref: ref,
                    source: UploadSource.CAMERA,
                  ),
                  text: "open camera",
                ),
              ],
            ),
    );
  }

  Widget _iconButtons(WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () => _uploadImage(
            ref: ref,
            source: UploadSource.MULTIPLE,
          ),
          icon: const Icon(CupertinoIcons.add),
        ),
        IconButton(
          onPressed: () => _uploadImage(
            ref: ref,
            source: UploadSource.CAMERA,
          ),
          icon: const Icon(CupertinoIcons.camera),
        ),
      ],
    );
  }

  Widget _image({
    required WidgetRef ref,
    required int index,
    required String path,
  }) {
    return Stack(
      children: [
        Image.file(
          File(path),
          fit: BoxFit.cover,
          width: double.infinity,
        ),
        Positioned(
            top: 1,
            left: 1,
            right: 1,
            bottom: 1,
            child: IconButton(
              onPressed: () {
                ref.read(uploadImageStateProvider.notifier).removeWhere(index);
              },
              icon: Icon(
                CupertinoIcons.delete,
                color: Colors.white.withOpacity(0.6),
              ),
            )),
      ],
    );
  }

  Widget _multipleImages({
    required BuildContext context,
    required WidgetRef ref,
    required List<XFile> images,
  }) {
    return images.isEmpty
        ? _selectOneImage(
            context: context,
            ref: ref,
            images: images,
            fromMultipleSelect: true,
          )
        : images.length == 1
            ? SizedBox(
                height: height,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                        child: _image(
                      ref: ref,
                      index: 0,
                      path: images[0].path,
                    )),
                    const SizedBox(width: 5),
                    Expanded(child: _iconButtons(ref))
                  ],
                ))
            : images.length == 2
                ? SizedBox(
                    height: height,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                            child: _image(
                          ref: ref,
                          index: 0,
                          path: images[0].path,
                        )),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                  child: _image(
                                ref: ref,
                                index: 1,
                                path: images[1].path,
                              )),
                              const SizedBox(height: 5),
                              Expanded(child: _iconButtons(ref))
                            ],
                          ),
                        ),
                      ],
                    ))
                : SizedBox(
                    height: height,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                            child: _image(
                          ref: ref,
                          index: 0,
                          path: images[0].path,
                        )),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            children: [
                              Expanded(
                                  child: _image(
                                ref: ref,
                                index: 1,
                                path: images[1].path,
                              )),
                              const SizedBox(height: 5),
                              Expanded(
                                  child: _image(
                                ref: ref,
                                index: 2,
                                path: images[2].path,
                              )),
                            ],
                          ),
                        ),
                      ],
                    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final images = ref.watch(uploadImageStateProvider).images;

    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.purpleAccent.shade400),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: isMultipleImage
            ? _multipleImages(
                context: context,
                ref: ref,
                images: images,
              )
            : _selectOneImage(
                context: context,
                ref: ref,
                images: images,
              ),
      ),
    );
  }
}
