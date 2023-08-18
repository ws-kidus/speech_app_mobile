import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/provider/authProviders/authProvider.dart';
import 'package:speech/provider/authProviders/signInProvider.dart';
import 'package:speech/repo/authRepo.dart';

class SignInService extends StateNotifier<SignInState> {
  final Ref ref;
  late FlutterSecureStorage _storage;

  SignInService({required this.ref})
      : super(const SignInState(signInUIState: SignInUIState.NONE)) {
    _storage = const FlutterSecureStorage();
  }

  storeCredentials({
    required String email,
    required String password,
  }) {
    final data = {"email": email, "password": password};
    _storage.write(key: SignInState.storageKey, value: json.encode(data));
  }

  Future<Map<String, dynamic>?> retrieveCredentials() async {
    final stored = await _storage.read(key: SignInState.storageKey);
    return stored == null ? null : json.decode(stored);
  }

  signIn({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    email = email.trim();
    password = email.trim();

    if (rememberMe) {
      storeCredentials(email: email, password: password);
    }

    debugPrint("INITIALIZE SIGNIN");
    state = state.copyWith(signInUIState: SignInUIState.LOADING);
    try {
      final response = await AuthRepo.signIn(email: email, password: password);

      if (response.data != null) {
        final token = response.data['token'];
        await ref
            .read(authStateProvider.notifier)
            .storeToken(accessToken: token);

        state = state.copyWith(signInUIState: SignInUIState.OK);

        ref.read(authStateProvider.notifier).checkAuthState();
      } else {
        state = state.copyWith(
          signInUIState: SignInUIState.ERROR,
          errorMessage: "ERROR",
        );
      }
    } on DioException catch (ex) {
      debugPrint("ERROR ON INITIALIZE SIGNIN");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");

      late String errorMessage;
      if (ex.response != null) {
        debugPrint("ERROR RESPONSE: ${ex.response!.data}");
        errorMessage =
            ex.response!.data['error'] ?? "There seems to be a problem";
      } else {
        debugPrint("ERROR RESPONSE: null");
        errorMessage = "There seems to be a problem";
      }

      state = state.copyWith(
        signInUIState: SignInUIState.ERROR,
        errorMessage: errorMessage,
      );
    } catch (e) {
      debugPrint("ERROR ON INITIALIZE SIGNIN");
      debugPrint("Error Occurred ${e.toString()}");
      state = state.copyWith(
        signInUIState: SignInUIState.ERROR,
        errorMessage: "There seems to be a problem",
      );
    }
  }
}
