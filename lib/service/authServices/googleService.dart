import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/provider/authProviders/googleProvider.dart';

class GoogleService extends StateNotifier<GoogleState> {
  final Ref ref;

  GoogleService({
    required this.ref,
  }) : super(
          const GoogleState(
            googleSignInUIState: GoogleSignInUIState.NONE,
          ),
        );

  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() async {
    debugPrint("GOOGLE LOGIN");
    GoogleSignInAccount? account;
    try {
      account = await _googleSignIn.signIn();
    } on Exception catch (e) {
      debugPrint("ERROR ON INITIALIZE GOOGLE LOGIN");
      debugPrint("ERROR: $e");
    }
    return account;
  }

  signInWithGoogle() async {
    debugPrint("INITIALIZE GOOGLE LOGIN");
    state = state.copyWith(googleSignInUIState: GoogleSignInUIState.LOADING);
    try {
      final account = await login();

      if (account == null) {
        state = state.copyWith(googleSignInUIState: GoogleSignInUIState.ERROR);
        return;
      }

      state = state.copyWith(googleSignInUIState: GoogleSignInUIState.OK);


    } on DioException catch (ex) {
      debugPrint("ERROR ON INITIALIZE GOOGLE LOGIN");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");
      state = state.copyWith(googleSignInUIState: GoogleSignInUIState.ERROR);
    } catch (e) {
      debugPrint("ERROR ON INITIALIZE GOOGLE LOGIN");
      debugPrint("Error Occurred ${e.toString()}");
      state = state.copyWith(googleSignInUIState: GoogleSignInUIState.ERROR);
    }
  }
}
