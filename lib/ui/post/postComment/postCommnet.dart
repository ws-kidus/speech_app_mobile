import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:speech/model/postCommentModel.dart';
import 'package:speech/model/postModel.dart';
import 'package:speech/provider/postCommentProvider.dart';
import 'package:speech/ui/post/postCreator/creatorProfileAvatar.dart';
import 'package:speech/ui/widgets/widgets.dart';
import 'package:speech/utils/timeUtils.dart';

class PostComment extends HookConsumerWidget {
  final PostModel post;

  const PostComment({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postCommentStateProvider).postCommentUIState;
    final postComments = ref.read(postCommentStateProvider).postComments;

    late Widget body;
    switch (state) {
      case PostCommentUIState.NONE:
      case PostCommentUIState.LOADING:
        body = Center(
          child: AppWidgets.loadingAnimation(size: 30),
        );
        break;

      case PostCommentUIState.DONE:
        body = postComments.isEmpty
            ? Center(
                child: Text(
                  "Be the first to comment",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              )
            : ListView.builder(
                itemCount: postComments.length,
                itemBuilder: (context, index) {
                  final postComment = postComments[index];
                  return _SinglePostComment(postComment: postComment);
                },
              );
        break;

      case PostCommentUIState.ERROR:
        body = Center(
          child: Text(
            "There seems to be a problem",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        );
        break;
    }

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Comments",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
          Expanded(child: body),
          _CommentForm(post: post),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class _CommentForm extends HookConsumerWidget {
  final PostModel post;

  const _CommentForm({
    Key? key,
    required this.post,
  }) : super(key: key);

  void _onComment({
    required GlobalKey<FormState> formKey,
    required TextEditingController commentController,
  }) {
    if (formKey.currentState!.validate()) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final commentController =
        useTextEditingController.fromValue(TextEditingValue.empty);

    return Form(
      key: formKey,
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Comment field can not be empty";
          }
          return null;
        },
        textInputAction: TextInputAction.done,
        controller: commentController,
        keyboardType: TextInputType.text,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.white,
            ),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          labelText: "Comment",
          labelStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
              ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(10),
          ),
          suffixIcon: IconButton(
            onPressed: () => _onComment(
              formKey: formKey,
              commentController: commentController,
            ),
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class _SinglePostComment extends ConsumerWidget {
  final PostCommentModel postComment;

  const _SinglePostComment({
    Key? key,
    required this.postComment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ExpansionTile(
        leading: const CreatorProfileAvatar(),
        title: Text(
          postComment.comment,
          style: Theme.of(context).textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          TimeUtils.datePlusTime(postComment.createdAt),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: _LikeButton(postComment: postComment),
        expandedAlignment: Alignment.centerLeft,
        childrenPadding: const EdgeInsets.symmetric(horizontal: 8).copyWith(
          bottom: 5,
        ),
        children: [
          Text(
            postComment.comment,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _LikeButton extends HookConsumerWidget {
  final PostCommentModel postComment;
  late int _likeCount;

  _LikeButton({
    Key? key,
    required this.postComment,
  }) : super(key: key) {
    _likeCount = postComment.likeCount;
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
    final isLiked = useState<bool>(postComment.liked);

    const iconSize = 23.0;
    return IconButton(
      onPressed: () => _onLike(ref, isLiked),
      icon: Column(
        children: [
          isLiked.value
              ? const Icon(
                  CupertinoIcons.heart_fill,
                  color: Colors.redAccent,
                  size: iconSize,
                )
              : const Icon(
                  CupertinoIcons.heart,
                  size: iconSize,
                ),
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
