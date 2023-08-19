import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/provider/authProviders/authProvider.dart';
import 'package:speech/provider/authProviders/signUpProvider.dart';
import 'package:speech/repo/authRepo.dart';

class SignUpService extends StateNotifier<SignUpState> {
  final Ref ref;

  SignUpService({required this.ref})
      : super(
          const SignUpState(
            signUpUIState: SignUpUIState.NONE,
          ),
        );

  signUp({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    name = name.trim();
    email = email.trim();
    password = email.trim();

    debugPrint("INITIALIZE SIGNUP");
    state = state.copyWith(signUpUIState: SignUpUIState.LOADING);
    try {
      final response = await AuthRepo.signUp(
        name: name,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      if (response.data != null) {
        final token = response.data['token'];
        await ref
            .read(authStateProvider.notifier)
            .storeToken(accessToken: token);

        state = state.copyWith(signUpUIState: SignUpUIState.OK);

        ref.read(authStateProvider.notifier).checkAuthState();
      } else {
        state = state.copyWith(
          signUpUIState: SignUpUIState.ERROR,
          errorMessage: "ERROR",
        );
      }
    } on DioException catch (ex) {
      debugPrint("ERROR ON INITIALIZE SIGNUP");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");

      late String errorMessage;
      if (ex.response != null) {
        debugPrint("ERROR RESPONSE: ${ex.response!.data}");
        errorMessage =
            ex.response!.data['message'] ?? "There seems to be a problem";
      } else {
        debugPrint("ERROR RESPONSE: null");
        errorMessage = "There seems to be a problem";
      }

      state = state.copyWith(
        signUpUIState: SignUpUIState.ERROR,
        errorMessage: errorMessage,
      );
    } catch (e) {
      debugPrint("ERROR ON INITIALIZE SIGNUP");
      debugPrint("Error Occurred ${e.toString()}");
      state = state.copyWith(
        signUpUIState: SignUpUIState.ERROR,
        errorMessage: "There seems to be a problem",
      );
    }
  }
}
