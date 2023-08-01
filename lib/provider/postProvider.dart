
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/model/postModel.dart';
import 'package:speech/service/postService.dart';

enum PostUIState { NONE, LOADING, DONE, ERROR }

enum LoadMoreUIState { NONE, LOADING, DONE, ERROR }

enum CreatePostUIState { NONE, LOADING, OK, ERROR }


class PostState {
  final PostUIState postUIState;
  final List<PostModel> posts;
  final LoadMoreUIState loadMoreUIState;
  final CreatePostUIState createPostUIState;

  const PostState({
    required this.postUIState,
    required this.posts,
    required this.loadMoreUIState,
    required this.createPostUIState,
  });

  PostState copyWith({
    PostUIState? postUIState,
    List<PostModel>? posts,
    LoadMoreUIState? loadMoreUIState,
    CreatePostUIState? createPostUIState,
  }) {
    return PostState(
      postUIState: postUIState ?? this.postUIState,
      posts: posts ?? this.posts,
      loadMoreUIState: loadMoreUIState ?? this.loadMoreUIState,
      createPostUIState: createPostUIState ?? this.createPostUIState,
    );
  }
}

final postStateProvider = StateNotifierProvider<PostService, PostState>((ref) {
  return PostService(ref: ref);
});
