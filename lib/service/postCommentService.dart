import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/model/postCommentModel.dart';
import 'package:speech/provider/postCommentProvider.dart';

class PostCommentService extends StateNotifier<PostCommentState> {
  final Ref ref;

  PostCommentService({required this.ref})
      : super(
          const PostCommentState(
            postCommentUIState: PostCommentUIState.NONE,
            postComments: [],
          ),
        );

  fetchPostComments(int postId) async {
    debugPrint("INITIALIZING POST COMMENTS");
    state = state.copyWith(postCommentUIState: PostCommentUIState.LOADING);
    try {
      final List<PostCommentModel> postComments = [
        PostCommentModel(
          id: 1,
          creatorId: 1,
          postId: 1,
          comment: "comment 1",
          liked: true,
          likeCount: 1,
          createdAt: DateTime.now(),
        ),
        PostCommentModel(
          id: 2,
          creatorId: 2,
          postId: 1,
          comment:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          liked: false,
          likeCount: 45,
          createdAt: DateTime.now(),
        ),
      ];
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        postCommentUIState: PostCommentUIState.DONE,
        postComments: postComments,
      );
    } on DioException catch (ex) {
      debugPrint("ERROR ON INITIALIZING POST COMMENTS");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");
      state = state.copyWith(postCommentUIState: PostCommentUIState.ERROR);
    } catch (e) {
      debugPrint("ERROR ON INITIALIZING POST COMMENTS");
      debugPrint("Error Occurred ${e.toString()}");
      state = state.copyWith(postCommentUIState: PostCommentUIState.ERROR);
    }
  }
}
