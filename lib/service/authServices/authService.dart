import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/provider/authProviders/authProvider.dart';
import 'package:speech/provider/userProvider.dart';

class AuthService extends StateNotifier<AuthState> {
  final Ref ref;
  late FlutterSecureStorage _storage;

  AuthService({
    required this.ref,
  }) : super(
          AuthState(
            authorizationState: AuthorizationState.NONE,
            accessToken: [],
          ),
        ) {
    _storage = const FlutterSecureStorage();
    checkAuthState();
  }

  storeToken({
    required String accessToken,
  }) async {
    final data = {'accessToken': accessToken};
    await _storage.write(key: AuthState.storageKey, value: json.encode(data));
    debugPrint("STORED ACCESS TOKEN");

  }

  checkAuthState() async {
    debugPrint("CHECKING AUTH STATE");
    state = state.copyWith(
      authorizationState: AuthorizationState.LOADING,
    );

    final stored = await _storage.read(key: AuthState.storageKey);

    if (stored == null) {
      state = state.copyWith(
        authorizationState: AuthorizationState.UNAUTHORIZED,
        accessToken: [],
      );
      return;
    }

    final data = json.decode(stored);
    print("++data ${data['accessToken']}");
    state = state.copyWith(accessToken: [data['accessToken']]);

    await ref.read(userStateProvider.notifier).fetchUser();

    final isOK = ref.read(userStateProvider).userUIState == UserUIState.DONE;

    if(isOK){
      state = state.copyWith(
        authorizationState: AuthorizationState.AUTHORIZED,
      );
    }else{
      state = state.copyWith(
        authorizationState: AuthorizationState.UNAUTHORIZED,
      );
    }
  }
}
