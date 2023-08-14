import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/model/userModel.dart';
import 'package:speech/service/userService.dart';

enum UserUIState { NONE, LOADING, DONE, ERROR }

class UserState {
  final UserUIState userUIState;
  final List<UserModel> user;

  const UserState({
    required this.userUIState,
    required this.user,
  });

  UserState copyWith({
    UserUIState? userUIState,
    List<UserModel>? user,
  }) {
    return UserState(
      userUIState: userUIState ?? this.userUIState,
      user: user ?? this.user,
    );
  }
}

final userStateProvider = StateNotifierProvider<UserService, UserState>((ref) {
  return UserService(ref: ref);
});

