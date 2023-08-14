import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:speech/provider/authProviders/googleProvider.dart';
import 'package:speech/ui/widgets/dialogs.dart';
import 'package:speech/ui/widgets/widgets.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({
    Key? key,
  }) : super(key: key);

  Future<void> _onPressed(BuildContext context, WidgetRef ref) async {
    await ref.read(googleSignInStateProvider.notifier).signInWithGoogle();
    final isOK = ref.read(googleSignInStateProvider).googleSignInUIState ==
        GoogleSignInUIState.OK;

    if (context.mounted) {
      if (isOK) {
      } else {
        Dialogs.toast(
          context: context,
          message: "There seems to be a problem, try again",
          buttonText: "Close",
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(googleSignInStateProvider).googleSignInUIState;
    switch (state) {
      case GoogleSignInUIState.LOADING:
        return AppWidgets.loadingAnimation();
      default:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.white),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _onPressed(context, ref),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                FontAwesomeIcons.google,
                color: Colors.white,
              ),
              const SizedBox(width: 10),
              Text(
                "Sign in with Google",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                ),
              )
            ],
          ),
        );
    }
  }
}
