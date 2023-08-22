import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/provider/authProviders/authProvider.dart';
import 'package:speech/provider/authProviders/socialSignInProvider.dart';
import 'package:speech/repo/authRepo.dart';

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

      final id = account.id.toString();
      final name = account.displayName ?? account.email.split("@")[0];
      final email = account.email;
      final photoUrl = account.photoUrl;

      final response = await AuthRepo.socialAuth(
        name: name,
        email: email,
        password: id,
        photoUrl: photoUrl,
        type: 2,
      );

      if (response.data != null) {
        final token = response.data['token'];
        await ref
            .read(authStateProvider.notifier)
            .storeToken(accessToken: token);

        state = state.copyWith(googleSignInUIState: GoogleSignInUIState.OK);

        ref.read(authStateProvider.notifier).checkAuthState();
      } else {
        state = state.copyWith(
          googleSignInUIState: GoogleSignInUIState.ERROR,
          errorMessage: "ERROR",
        );
      }
    } on DioException catch (ex) {
      debugPrint("ERROR ON INITIALIZE GOOGLE LOGIN");
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
        googleSignInUIState: GoogleSignInUIState.ERROR,
        errorMessage: errorMessage,
      );
    } catch (e) {
      debugPrint("ERROR ON INITIALIZE GOOGLE LOGIN");
      debugPrint("Error Occurred ${e.toString()}");
      state = state.copyWith(
        googleSignInUIState: GoogleSignInUIState.ERROR,
        errorMessage: "There seems to be a problem",
      );
    }
  }

  //  </editor-fold>

//<editor-fold desc = "Facebook">
  static final _facebookSignIn = FacebookAuth.instance;

  static Future<Map<String, dynamic>?> fetchFacebookUser() async {
    debugPrint("FACEBOOK LOGIN");
    Map<String, dynamic>? user;
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        user = await _facebookSignIn.getUserData();
      }
    } on Exception catch (e) {
      debugPrint("ERROR ON INITIALIZE FACEBOOK LOGIN");
      debugPrint("ERROR: $e");
    }
    return user;
  }

  signInWithFacebook() async {
    debugPrint("INITIALIZE FACEBOOK LOGIN");
    state =
        state.copyWith(facebookSignInUIState: FacebookSignInUIState.LOADING);
    try {
      final user = await fetchFacebookUser();

      if (user == null) {
        state =
            state.copyWith(facebookSignInUIState: FacebookSignInUIState.ERROR);
        return;
      }

      final id = user['id'];
      final name = user['name'] ?? user['email'].split("@")[0];
      final email = user['email'];
      final photoUrl = user['picture']['data']['url'];

      final response = await AuthRepo.socialAuth(
        name: name,
        email: email,
        password: id,
        photoUrl: photoUrl,
        type: 3,
      );

      if (response.data != null) {
        final token = response.data['token'];
        await ref
            .read(authStateProvider.notifier)
            .storeToken(accessToken: token);

        state = state.copyWith(
          facebookSignInUIState: FacebookSignInUIState.OK,
        );

        ref.read(authStateProvider.notifier).checkAuthState();
      } else {
        state = state.copyWith(
          facebookSignInUIState: FacebookSignInUIState.ERROR,
          errorMessage: "ERROR",
        );
      }
    } on DioException catch (ex) {
      debugPrint("ERROR ON INITIALIZE FACEBOOK LOGIN");
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
        facebookSignInUIState: FacebookSignInUIState.ERROR,
        errorMessage: errorMessage,
      );
    } catch (e) {
      debugPrint("ERROR ON INITIALIZE FACEBOOK LOGIN");
      debugPrint("Error Occurred ${e.toString()}");
      state = state.copyWith(
        facebookSignInUIState: FacebookSignInUIState.ERROR,
        errorMessage:"There seems to be a problem",
      );
    }
  }

//</editor-fold>
}
