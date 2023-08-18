import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/service/authServices/signUpService.dart';

enum SignUpUIState { NONE, LOADING, OK, ERROR }

class SignUpState {
  final SignUpUIState signUpUIState;
  final String? errorMessage;

  const SignUpState({
    required this.signUpUIState,
    this.errorMessage,
  });

  SignUpState copyWith({
    SignUpUIState? signUpUIState,
    String? errorMessage,
  }) {
    return SignUpState(
      signUpUIState: signUpUIState ?? this.signUpUIState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final signUpStateProvider =
    StateNotifierProvider<SignUpService, SignUpState>((ref) {
  return SignUpService(ref: ref);
});
