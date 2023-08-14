import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/service/authServices/authService.dart';

enum AuthorizationState { NONE, LOADING, AUTHORIZED, UNAUTHORIZED }

class AuthState {
  final AuthorizationState authorizationState;
  final List<String> accessToken;

  AuthState({
    required this.authorizationState,
    required this.accessToken,
  });

  static const storageKey = "authKey";

  AuthState copyWith({
    AuthorizationState? authorizationState,
    List<String>? accessToken,
  }) {
    return AuthState(
      authorizationState: authorizationState ?? this.authorizationState,
      accessToken: accessToken ?? this.accessToken,
    );
  }
}

final authStateProvider = StateNotifierProvider<AuthService, AuthState>((ref) {
  return AuthService(ref: ref);
});

