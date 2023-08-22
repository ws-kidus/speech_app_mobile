import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/service/authServices/socialSignInService.dart';

enum GoogleSignInUIState { NONE, LOADING, OK, ERROR }
enum FacebookSignInUIState { NONE, LOADING, OK, ERROR }

class SocialSignInState {
  final GoogleSignInUIState googleSignInUIState;
  final FacebookSignInUIState facebookSignInUIState;
  final String? errorMessage;


  const SocialSignInState({
    required this.googleSignInUIState,
    required this.facebookSignInUIState,
    this.errorMessage,
  });

  SocialSignInState copyWith({
    GoogleSignInUIState? googleSignInUIState,
    FacebookSignInUIState? facebookSignInUIState,
    String? errorMessage,
  }) {
    return SocialSignInState(
      googleSignInUIState: googleSignInUIState ?? this.googleSignInUIState,
      facebookSignInUIState:
          facebookSignInUIState ?? this.facebookSignInUIState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

final socialSignInStateProvider =
    StateNotifierProvider<SocialSignInService, SocialSignInState>((ref) {
  return SocialSignInService(ref: ref);
});
