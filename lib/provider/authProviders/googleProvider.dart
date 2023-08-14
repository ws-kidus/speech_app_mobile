import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/service/authServices/googleService.dart';

enum GoogleSignInUIState { NONE, LOADING, OK, ERROR }

class GoogleState {
  final GoogleSignInUIState googleSignInUIState;

  const GoogleState({
    required this.googleSignInUIState,
  });

  GoogleState copyWith({
    GoogleSignInUIState? googleSignInUIState,
  }) {
    return GoogleState(
      googleSignInUIState: googleSignInUIState ?? this.googleSignInUIState,
    );
  }
}

final googleSignInStateProvider =
    StateNotifierProvider<GoogleService, GoogleState>((ref) {
  return GoogleService(ref: ref);
});
