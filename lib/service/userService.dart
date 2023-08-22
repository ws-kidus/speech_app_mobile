import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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

  Future<bool> changeBackgroundImage({required XFile image}) async {
    debugPrint("CHANGING BACKGROUND IMAGE");
    try {
      final accessToken = ref.read(authStateProvider).accessToken.first;
      final options = Options(headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
        "Content-Type": "multipart/form-data",
      });
      final response = await UserRepo.changeBackgroundImage(
        options: options,
        image: image,
      );
      if (response) {
        fetchUser();
      }
      return response;
    } on DioException catch (ex) {
      debugPrint("ERROR ON CHANGING BACKGROUND IMAGE");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");

      if (ex.response != null) {
        debugPrint("ERROR RESPONSE: ${ex.response!.data}");
      } else {
        debugPrint("ERROR RESPONSE: null");
      }
      return false;
    } catch (e) {
      debugPrint("ERROR ON CHANGING BACKGROUND IMAGE");
      debugPrint("Error Occurred ${e.toString()}");
      return false;
    }
  }

  Future<bool> changeProfileImage({required XFile image}) async {
    debugPrint("CHANGING PROFILE IMAGE");
    try {
      final accessToken = ref.read(authStateProvider).accessToken.first;
      final options = Options(headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
        "Content-Type": "multipart/form-data",
      });

      final response = await UserRepo.changeProfileImage(
        options: options,
        image: image,
      );

      if (response) {
        fetchUser();
      }

      return response;
    } on DioException catch (ex) {
      debugPrint("ERROR ON CHANGING PROFILE IMAGE");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");

      if (ex.response != null) {
        debugPrint("ERROR RESPONSE: ${ex.response!.data}");
      } else {
        debugPrint("ERROR RESPONSE: null");
      }
      return false;
    } catch (e) {
      debugPrint("ERROR ON CHANGING PROFILE IMAGE");
      debugPrint("Error Occurred ${e.toString()}");
      return false;
    }
  }

  Future<bool> changeUserDetails({ String? name, String? phone,}) async {
    debugPrint("CHANGING USER DETAILS");
    try {
      final accessToken = ref.read(authStateProvider).accessToken.first;
      final options = Options(headers: {
        "Authorization": "Bearer $accessToken",
        "Accept": "application/json",
      });
      final response = await UserRepo.updateUserDetails(
        options: options,
        name: name,
        phone: phone,
      );
      if (response) {
        fetchUser();
      }
      return response;
    } on DioException catch (ex) {
      debugPrint("ERROR ON CHANGING USER DETAILS");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");

      if (ex.response != null) {
        debugPrint("ERROR RESPONSE: ${ex.response!.data}");
      } else {
        debugPrint("ERROR RESPONSE: null");
      }
      return false;
    } catch (e) {
      debugPrint("ERROR ON CHANGING USER DETAILS");
      debugPrint("Error Occurred ${e.toString()}");
      return false;
    }
  }
}
