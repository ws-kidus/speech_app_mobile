import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:share_plus/share_plus.dart';
import 'package:speech/constants/constants.dart';
import 'package:speech/model/postModel.dart';
import 'package:speech/provider/postCommentProvider.dart';
import 'package:speech/provider/postProvider.dart';
import 'package:speech/ui/post/postImage.dart';
import 'package:speech/ui/postComment/postCommnet.dart';
import 'package:speech/ui/profile/profileAvatar.dart';
import 'package:speech/ui/widgets/carousel.dart';
import 'package:speech/ui/widgets/dialogs.dart';
import 'package:speech/ui/widgets/widgets.dart';
import 'package:speech/utils/timeUtils.dart';

class PostScreen extends ConsumerWidget {
  const PostScreen({
    Key? key,
  }) : super(key: key);

  _onRetry(WidgetRef ref) {
    ref.read(postStateProvider.notifier).init();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postStateProvider).postUIState;

    final posts = ref.read(postStateProvider).posts;

    switch (state) {
      case PostUIState.NONE:
      case PostUIState.LOADING:
        return Center(
          child: AppWidgets.loadingAnimation(),
        );
      case PostUIState.ERROR:
        return Center(
          child: AppWidgets.errorMessage(
            context: context,
            function: () => _onRetry(ref),
          ),
        );
      case PostUIState.DONE:
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return _SinglePost(post: post);
          },
        );
    }
  }
}

class _SinglePost extends ConsumerWidget {
  final PostModel post;

  const _SinglePost({
    Key? key,
    required this.post,
  }) : super(key: key);

  _onComment(BuildContext context, WidgetRef ref) {
    ref.read(postCommentStateProvider.notifier).fetchPostComments(post.id);
    Dialogs.bottomSheet(
      context: context,
      child: PostComment(post: post),
      avoidBottomInsects: true,
    );
  }

  _onRepost(BuildContext context, WidgetRef ref) {}

  _onShare(BuildContext context, WidgetRef ref) async {
    final box = context.findRenderObject() as RenderBox?;

    await Share.share(
      post.speech,
      subject: "Speech app",
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }

  _onPostImageTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostImages(images: post.images),
      ),
    );
  }

  Widget _postImage({
    required BuildContext context,
    required String imageUrl,
  }) {
    const radius = 15.0;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(radius),
            topRight: Radius.circular(radius),
          ),
          child: Image(
            image: imageProvider,
            fit: BoxFit.cover,
          )),
      placeholder: (context, url) => AppWidgets.loadingAnimation(),
      errorWidget: (context, url, error) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
        child: Image.asset(
          LocalImages.noImage,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _actionButton({
    required BuildContext context,
    required WidgetRef ref,
    required VoidCallback onPressed,
    required IconData iconData,
    required String count,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: Column(
        children: [
          Icon(iconData),
          Text(
            count,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.grey,
                ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      child: Column(
        children: [
          if (post.images.isNotEmpty)
            GestureDetector(
              onTap: () => _onPostImageTap(context),
              child: Carousel(
                items: post.images
                    .map((image) => _postImage(
                          context: context,
                          imageUrl: image.imageUrl,
                        ))
                    .toList(),
                showIndicators: true,
              ),
            ),
          Material(
            elevation: 8,
            borderRadius: BorderRadius.only(
              bottomLeft: const Radius.circular(15),
              bottomRight: const Radius.circular(15),
              topLeft: post.images.isNotEmpty
                  ? Radius.zero
                  : const Radius.circular(15),
              topRight: post.images.isNotEmpty
                  ? Radius.zero
                  : const Radius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ProfileAvatar(),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          post.speech,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _LikeButton(post: post),
                      _actionButton(
                        context: context,
                        ref: ref,
                        onPressed: () => _onComment(context, ref),
                        iconData: CupertinoIcons.bubble_left_bubble_right,
                        count: post.commentCount.toString(),
                      ),
                      _actionButton(
                        context: context,
                        ref: ref,
                        onPressed: () => _onRepost(context, ref),
                        iconData: CupertinoIcons.arrow_2_squarepath,
                        count: post.repostCount.toString(),
                      ),
                      _actionButton(
                        context: context,
                        ref: ref,
                        onPressed: () => _onShare(context, ref),
                        iconData: Icons.share,
                        count: "share",
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      TimeUtils.datePlusTime(post.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LikeButton extends HookConsumerWidget {
  final PostModel post;
  late int _likeCount;

  _LikeButton({
    Key? key,
    required this.post,
  }) : super(key: key) {
    _likeCount = post.likeCount;
  }

  _onLike(WidgetRef ref, ValueNotifier<bool> notifier) {
    if (notifier.value) {
      _likeCount -= 1;
    } else {
      _likeCount += 1;
    }
    notifier.value = !notifier.value;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = useState<bool>(post.liked);

    return IconButton(
      onPressed: () => _onLike(ref, isLiked),
      icon: Column(
        children: [
          isLiked.value
              ? const Icon(CupertinoIcons.heart_fill, color: Colors.redAccent)
              : const Icon(CupertinoIcons.heart),
          Text(
            _likeCount.toString(),
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: Colors.grey,
                ),
          )
        ],
      ),
    );
  }
}
