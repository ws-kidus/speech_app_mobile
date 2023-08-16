import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/model/userModel.dart';
import 'package:speech/provider/authProviders/authProvider.dart';
import 'package:speech/provider/userProvider.dart';
import 'package:speech/repo/userRepo.dart';

class UserService extends StateNotifier<UserState> {
  final Ref ref;

  UserService({
    required this.ref,
  }) : super(
          const UserState(
            userUIState: UserUIState.NONE,
            user: [],
          ),
        );

  fetchUser() async {
    debugPrint("INITIALIZING USER");
    try {
      final List<UserModel> user = [];

      final accessToken = ref.read(authStateProvider).accessToken.first;
      final options = Options(headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      });

      final response = await UserRepo.fetchUser(options: options);

      if (response.data != null) {
        final List result = [response.data['result']];
        result.map((e) => user.add(UserModel.fromMap(e))).toList();
      }

      state = state.copyWith(userUIState: UserUIState.DONE, user: user);
    } on DioException catch (ex) {
      debugPrint("ERROR ON INITIALIZING USER");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");

      if (ex.response != null) {
        debugPrint("ERROR RESPONSE: ${ex.response!.data}");
      } else {
        debugPrint("ERROR RESPONSE: null");
      }

      state = state.copyWith(userUIState: UserUIState.ERROR);
    } catch (e) {
      debugPrint("ERROR ON INITIALIZING USER");
      debugPrint("Error Occurred ${e.toString()}");
      state = state.copyWith(userUIState: UserUIState.ERROR);
    }
  }
}
