import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/service/authServices/socialSignInService.dart';

enum GoogleSignInUIState { NONE, LOADING, OK, ERROR }
enum FacebookSignInUIState { NONE, LOADING, OK, ERROR }

class SocialSignInState {
  final GoogleSignInUIState googleSignInUIState;
  final FacebookSignInUIState facebookSignInUIState;

  const SocialSignInState({
    required this.googleSignInUIState,
    required this.facebookSignInUIState,
  });

  SocialSignInState copyWith({
    GoogleSignInUIState? googleSignInUIState,
    FacebookSignInUIState? facebookSignInUIState,
  }) {
    return SocialSignInState(
      googleSignInUIState: googleSignInUIState ?? this.googleSignInUIState,
      facebookSignInUIState:
          facebookSignInUIState ?? this.facebookSignInUIState,
    );
  }
}

final socialSignInStateProvider =
    StateNotifierProvider<SocialSignInService, SocialSignInState>((ref) {
  return SocialSignInService(ref: ref);
});
