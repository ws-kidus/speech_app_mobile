import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:speech/service/authServices/socialSignInService.dart';
import 'package:speech/ui/auth/facebookSignInButton.dart';
import 'package:speech/ui/auth/googleSignInButton.dart';

class AuthSelectionScreen extends ConsumerWidget {
  const AuthSelectionScreen({
    Key? key,
  }) : super(key: key);

  void _onGooglePressed() {
    SocialSignInService.fetchGoogleSignInAccount();
  }

  void _onFacebookPressed() {}

  void _onSignIn() {}

  void _onSignup() {}

  _button({
    required BuildContext context,
    required VoidCallback onPressed,
    required String text,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 8),
        side: const BorderSide(color: Colors.white),
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
                  onPressed: () => _onSignIn(),
                  text: "Sign in",
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _button(
                  context: context,
                  onPressed: () => _onSignup(),
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
                color: Colors.white,
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
          const Positioned.fill(child: _AnimatedBackground()),
          _body(context: context, ref: ref),
        ],
      ),
    );
  }
}

class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(
        "color1",
        ColorTween(
          begin: const Color(0xffD38312),
          end: Colors.lightBlue.shade900,
        ),
        duration: const Duration(seconds: 3),
      )
      .thenTween(
        "color2",
        ColorTween(
          begin: const Color(0xffA83279),
          end: Colors.blue.shade600,
        ),
        duration: const Duration(seconds: 3),
      );

    return MirrorAnimationBuilder(
      curve: Curves.easeIn,
      tween: tween,
      duration: tween.duration,
      builder: (context, value, _) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [value.get("color1"), value.get("color2")],
            ),
          ),
        );
      },
    );
  }
}
