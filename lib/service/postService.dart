import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech/model/postModel.dart';
import 'package:speech/provider/authProviders/authProvider.dart';
import 'package:speech/provider/postProvider.dart';
import 'package:speech/repo/postRepo.dart';

class PostService extends StateNotifier<PostState> {
  final Ref ref;


  PostService({
    required this.ref,
  }) : super(
          const PostState(
            postUIState: PostUIState.NONE,
            loadMoreUIState: LoadMoreUIState.NONE,
            posts: [],
            createPostUIState: CreatePostUIState.NONE,
          ),
        ) {
    init();
  }

  //<editor-fold desc = "fetching posts">
  int _postsPage = 1;
  int _totalPosts = 0;

  int get totalPosts => _totalPosts;

  loadMorePosts() async {
    debugPrint("LOADING MORE POSTS");
    state = state.copyWith(loadMoreUIState: LoadMoreUIState.LOADING);

    _postsPage += 1;
    await init();

    if (state.postUIState == PostUIState.DONE) {
      state = state.copyWith(loadMoreUIState: LoadMoreUIState.DONE);
    } else {
      state = state.copyWith(loadMoreUIState: LoadMoreUIState.ERROR);
    }
  }

  init() async {
    debugPrint("INITIALIZING POSTS");
    state = state.copyWith(postUIState: PostUIState.LOADING);
    try {
      List<PostModel> posts = state.posts;

      final accessToken = ref.read(authStateProvider).accessToken.first;
      final options = Options(
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json",
        },
      );

      final response = await PostRepo.fetchPosts(
        options: options,
        page: _postsPage,
      );

      if (response.data != null) {
        List result = response.data['result'];
        _totalPosts = response.data['total'];
        result.map((e) => posts.add(PostModel.fromMap(e))).toList();
      }

      state = state.copyWith(postUIState: PostUIState.DONE, posts: posts);
    } on DioException catch (ex) {
      debugPrint("ERROR ON INITIALIZING POSTS");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");

      if (ex.response != null) {
        debugPrint("ERROR RESPONSE: ${ex.response!.data}");
      } else {
        debugPrint("ERROR RESPONSE: null");
      }

      state = state.copyWith(postUIState: PostUIState.ERROR);
    } catch (e) {
      debugPrint("ERROR ON INITIALIZING POSTS");
      debugPrint("Error Occurred ${e.toString()}");
      state = state.copyWith(postUIState: PostUIState.ERROR);
    }
  }

//  </editor-fold>

//<editor-fold desc = "create post">
  createPost({
    required String speech,
    required List<XFile> images,
  }) async {
    speech = speech.trim();
    debugPrint("CREATING POSTS");
    state = state.copyWith(createPostUIState: CreatePostUIState.LOADING);
    try {

      final accessToken = ref.read(authStateProvider).accessToken.first;
      final options = Options(
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        },
      );

      final response = await PostRepo.createPost(
        options: options,
        speech: speech,
        images: images,
      );

      if (response) {
        state = state.copyWith(createPostUIState: CreatePostUIState.OK);
      } else {
        state = state.copyWith(createPostUIState: CreatePostUIState.ERROR);
      }
    } on DioException catch (ex) {
      debugPrint("ERROR ON CREATING POSTS");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");

      if (ex.response != null) {
        debugPrint("ERROR RESPONSE: ${ex.response!.data}");
      } else {
        debugPrint("ERROR RESPONSE: null");
      }

      state = state.copyWith(createPostUIState: CreatePostUIState.ERROR);
    } catch (e) {
      debugPrint("ERROR ON CREATING POSTS");
      debugPrint("Error Occurred ${e.toString()}");
      state = state.copyWith(createPostUIState: CreatePostUIState.ERROR);
    }
  }

//</editor-fold>

//<editor-fold desc = "update like count">
  updateLikeStatus({
    required String postId,
    required bool liked,
  }) async {
    debugPrint("UPDATE POST LIKE");
    try {

      final accessToken = ref.read(authStateProvider).accessToken.first;
      final options = Options(
        headers: {
          "Authorization": "Bearer $accessToken",
          "Accept": "application/json",
        },
      );

      final response = await PostRepo.updateLikeStatus(
        options: options,
        postId: postId,
        liked: liked,
      );

      if (!response) {
      //todo pending update actions
      }

    } on DioException catch (ex) {
      debugPrint("ERROR ON UPDATE POST LIKE");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");

      if (ex.response != null) {
        debugPrint("ERROR RESPONSE: ${ex.response!.data}");
      } else {
        debugPrint("ERROR RESPONSE: null");
      }

      //todo pending update actions
    } catch (e) {
      debugPrint("ERROR ON UPDATE POST LIKE");
      debugPrint("Error Occurred ${e.toString()}");
      //todo pending update actions
    }
  }
//</editor-fold>
}
