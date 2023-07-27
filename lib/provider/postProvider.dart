
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/model/postModel.dart';
import 'package:speech/service/postService.dart';

enum PostUIState { NONE, LOADING, DONE, ERROR }

class PostState {
  final PostUIState postUIState;
  final List<PostModel> posts;

  const PostState({
    required this.postUIState,
    required this.posts,
  });

  PostState copyWith({
    PostUIState? postUIState,
    List<PostModel>? posts,
  }) {
    return PostState(
      postUIState: postUIState ?? this.postUIState,
      posts: posts ?? this.posts,
    );
  }
}

final postStateProvider = StateNotifierProvider<PostService, PostState>((ref) {
  return PostService(ref: ref);
});
