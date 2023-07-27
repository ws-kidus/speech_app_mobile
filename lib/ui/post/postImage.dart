import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:speech/constants/constants.dart';
import 'package:speech/model/postModel.dart';
import 'package:speech/ui/widgets/carousel.dart';
import 'package:speech/ui/widgets/widgets.dart';

class PostImages extends HookConsumerWidget {
  final List<ImageModel> images;

  const PostImages({
    Key? key,
    required this.images,
  }) : super(key: key);

  void _handleDoubleTap({
    required TransformationController transformationController,
    required TapDownDetails doubleTapDetails,
  }) {
    if (transformationController.value != Matrix4.identity()) {
      transformationController.value = Matrix4.identity();
    } else {
      final position = doubleTapDetails.localPosition;
      // For a 3x zoom
      transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }

  Widget _postImage({
    required BuildContext context,
    required String imageUrl,
    required TransformationController transformationController,
  }) {
    late TapDownDetails doubleTapDetails;

    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => GestureDetector(
        onDoubleTapDown: (d) => doubleTapDetails = d,
        onDoubleTap: () => _handleDoubleTap(
          transformationController: transformationController,
          doubleTapDetails: doubleTapDetails,
        ),
        child: InteractiveViewer(
          transformationController: transformationController,
          child: Image(
            image: imageProvider,
            fit: BoxFit.contain,
          ),
        ),
      ),
      placeholder: (context, url) => AppWidgets.loadingAnimation(),
      errorWidget: (context, url, error) => Image.asset(
        LocalImages.noImage,
        fit: BoxFit.contain,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transformationController = useTransformationController();
    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Carousel(
            height: MediaQuery.of(context).size.height,
            items: images
                .map((image) => _postImage(
                      context: context,
                      imageUrl: image.imageUrl,
                      transformationController: transformationController,
                    ))
                .toList(),
            showIndicators: true,
          ),
          Positioned(
            left: 0,
            top: 0,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                CupertinoIcons.arrow_left,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
