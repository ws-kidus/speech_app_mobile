import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/provider/authProviders/socialSignInProvider.dart';
import 'package:speech/ui/widgets/dialogs.dart';
import 'package:speech/ui/widgets/widgets.dart';

class FacebookSignInButton extends ConsumerWidget {
  const FacebookSignInButton({
    Key? key,
  }) : super(key: key);

  Future<void> _onPressed(BuildContext context, WidgetRef ref) async {
    await ref.read(socialSignInStateProvider.notifier).signInWithFacebook();
    final isOK = ref.read(socialSignInStateProvider).facebookSignInUIState ==
        FacebookSignInUIState.OK;

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
    final state = ref.watch(socialSignInStateProvider).facebookSignInUIState;
    switch (state) {
      case FacebookSignInUIState.LOADING:
        return AppWidgets.loadingAnimation(
          size: 25,
          color: Colors.purpleAccent,
        );
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
                FontAwesomeIcons.facebook,
                color: Colors.purpleAccent,
              ),
              const SizedBox(width: 10),
              Text(
                "Sign in with Facebook",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.purpleAccent,
                    ),
              )
            ],
          ),
        );
    }
  }
}
