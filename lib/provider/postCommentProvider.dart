import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/model/postCommentModel.dart';
import 'package:speech/service/postCommentService.dart';

enum PostCommentUIState { NONE, LOADING, DONE, ERROR }

class PostCommentState {
  final PostCommentUIState postCommentUIState;
  final List<PostCommentModel> postComments;

  const PostCommentState({
    required this.postCommentUIState,
    required this.postComments,
  });

  PostCommentState copyWith({
    PostCommentUIState? postCommentUIState,
    List<PostCommentModel>? postComments,
  }) {
    return PostCommentState(
      postCommentUIState: postCommentUIState ?? this.postCommentUIState,
      postComments: postComments ?? this.postComments,
    );
  }
}

final postCommentStateProvider =
    StateNotifierProvider<PostCommentService, PostCommentState>((ref) {
  return PostCommentService(ref: ref);
});
