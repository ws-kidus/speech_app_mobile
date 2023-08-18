import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/ui/auth/facebookSignInButton.dart';
import 'package:speech/ui/auth/googleSignInButton.dart';
import 'package:speech/ui/auth/signUp.dart';
import 'package:speech/ui/auth/singIn.dart';
import 'package:speech/ui/widgets/animatedBackground.dart';

class AuthSelectionScreen extends ConsumerWidget {
  const AuthSelectionScreen({
    Key? key,
  }) : super(key: key);

  void _onSignIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignInScreen(),
      ),
    );
  }

  void _onSignup(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  _button({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8),
        backgroundColor: Colors.purpleAccent.shade200.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }

  Widget _body({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Expanded(
                child: _button(
                  context: context,
                  onPressed: () => _onSignIn(context),
                  text: "Sign in",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _button(
                  context: context,
                  onPressed: () => _onSignup(context),
                  text: "Sign up",
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "or continue with",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Colors.purpleAccent,
              ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: GoogleSignInButton(),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: FacebookSignInButton(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          const Positioned.fill(child: AnimatedBackground()),
          _body(context: context, ref: ref),
        ],
      ),
    );
  }
}

