import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/service/authServices/signinService.dart';

enum SignInUIState { NONE, LOADING, OK, ERROR }

class SignInState {
  final SignInUIState signInUIState;
  final String? errorMessage;

  const SignInState({
    required this.signInUIState,
    this.errorMessage,
  });

  static const String storageKey = "signIn";

  SignInState copyWith({
    SignInUIState? signInUIState,
    String? errorMessage,
  }) {
    return SignInState(
      signInUIState: signInUIState ?? this.signInUIState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final signInStateProvider =
    StateNotifierProvider<SignInService, SignInState>((ref) {
  return SignInService(ref: ref);
});
