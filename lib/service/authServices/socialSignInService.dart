import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/provider/authProviders/socialSignInProvider.dart';

class SocialSignInService extends StateNotifier<SocialSignInState> {
  final Ref ref;

  SocialSignInService({
    required this.ref,
  }) : super(
          const SocialSignInState(
            googleSignInUIState: GoogleSignInUIState.NONE,
            facebookSignInUIState: FacebookSignInUIState.NONE,
          ),
        );

  //<editor-fold desc= "Google">

  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> fetchGoogleSignInAccount() async {
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
      final account = await fetchGoogleSignInAccount();

      if (account == null) {
        state = state.copyWith(googleSignInUIState: GoogleSignInUIState.ERROR);
        return;
      }

      final id = account.id;
      final name = account.displayName;
      final email = account.email;
      final photoUrl = account.photoUrl;

      

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

  //  </editor-fold>

//<editor-fold desc = "Facebook">
  signInWithFacebook() async {
    debugPrint("INITIALIZE FACEBOOK LOGIN");
    state = state.copyWith(facebookSignInUIState: FacebookSignInUIState.LOADING);
    try {





      state = state.copyWith(facebookSignInUIState: FacebookSignInUIState.OK);


    } on DioException catch (ex) {
      debugPrint("ERROR ON INITIALIZE FACEBOOK LOGIN");
      debugPrint("DIO ERROR TYPE ${ex.type.name}");
      debugPrint("ERROR MESSAGE ${ex.error}");
      state = state.copyWith(facebookSignInUIState: FacebookSignInUIState.ERROR);
    } catch (e) {
      debugPrint("ERROR ON INITIALIZE FACEBOOK LOGIN");
      debugPrint("Error Occurred ${e.toString()}");
      state = state.copyWith(facebookSignInUIState: FacebookSignInUIState.ERROR);
    }
  }

//</editor-fold>

}
