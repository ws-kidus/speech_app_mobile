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
      if (!isOK) {
        final errorMessage = ref.read(socialSignInStateProvider).errorMessage ??
            "There seems to be a problem, try again";
        Dialogs.toast(
          context: context,
          message: errorMessage,
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
          color: Colors.deepPurple,
        );
      default:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.deepPurple),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () => _onPressed(context, ref),
          child: Row(
            children: [
              const Spacer(),
              const SizedBox(width: 20),
              const Icon(
                FontAwesomeIcons.facebook,
                color: Colors.deepPurple,
              ),
              const SizedBox(width: 10),
              Text(
                "Sign in with Facebook",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.deepPurple,
                    ),
              ),
              const Spacer(),
            ],
          ),
        );
    }
  }
}
