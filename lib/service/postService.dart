import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/model/postModel.dart';
import 'package:speech/provider/postProvider.dart';

class PostService extends StateNotifier<PostState> {
  final Ref ref;

  PostService({
    required this.ref,
  }) : super(
          const PostState(
            postUIState: PostUIState.NONE,
            posts: [],
          ),
        ) {
    init();
  }

  init() async {
    debugPrint("INITIALIZING POSTS");
    state = state.copyWith(postUIState: PostUIState.LOADING);
    try {
      List<PostModel> posts = [
        PostModel(
          id: 1,
          speech: "speech1",
          creatorId: 1,
          creatorName: "kidus",
          likeCount: 1,
          liked: true,
          commentCount: 0,
          repostCount: 100,
          images: [],
          createdAt: DateTime.now(),
        ),
        PostModel(
          id: 2,
          speech:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          creatorId: 2,
          creatorName: "ezra",
          likeCount: 0,
          liked: false,
          commentCount: 3,
          repostCount: 3,
          images: [
            ImageModel(
                id: 1,
                creatorId: 2,
                imageTitle: "1image.png",
                imageUrl: "https://source.unsplash.com/user/c_v_r/1900x800"),
          ],
          createdAt: DateTime.now(),
        ),
        PostModel(
          id: 3,
          speech: "speech1",
          creatorId: 3,
          creatorName: "abrham",
          likeCount: 35,
          commentCount: 5,
          repostCount: 15,
          liked: true,
          images: [
            ImageModel(
                id: 2,
                creatorId: 3,
                imageTitle: "2image.png",
                imageUrl: "https://source.unsplash.com/user/c_v_r/1900x800"),
            ImageModel(
                id: 3,
                creatorId: 3,
                imageTitle: "3image.png",
                imageUrl:
                    "https://img.freepik.com/free-photo/side-view-woman-eating-with-chopsticks_23-2149706743.jpg?w=1800&t=st=1690380663~exp=1690381263~hmac=1214511af7a6b4e6f76e0931c75e59fafac7e19efc189f80102b2f8e66e6ad9a"),
          ],
          createdAt: DateTime.now(),
        ),
      ];
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(postUIState: PostUIState.DONE, posts: posts);
    } on DioException catch (ex) {
      debugPrint("ERROR ON INITIALIZING POSTS");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");
      state = state.copyWith(postUIState: PostUIState.ERROR);
    } catch (e) {
      debugPrint("ERROR ON INITIALIZING POSTS");
      debugPrint("Error Occurred ${e.toString()}");
      state = state.copyWith(postUIState: PostUIState.ERROR);
    }
  }
}
