import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:speech/constants/theme.dart';
import 'package:speech/provider/authProviders/authProvider.dart';
import 'package:speech/ui/auth/authSelection.dart';
import 'package:speech/ui/base.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authStateProvider).authorizationState;

    late Widget home;
    switch (state) {
      case AuthorizationState.NONE:
      case AuthorizationState.LOADING:
        home = const Scaffold(
          body: _AnimatedLoading(),
        );
        break;
      case AuthorizationState.UNAUTHORIZED:
        home = const AuthSelectionScreen();
        break;
      case AuthorizationState.AUTHORIZED:
        home = const BaseScreen();
        break;
    }
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: home,
    );
  }
}

class _AnimatedLoading extends StatelessWidget {
  const _AnimatedLoading({super.key});

  @override
  Widget build(BuildContext context) {
    const speech = "Speech...";

    final tween = MovieTween()
      ..tween(
        "step",
        IntTween(begin: 0, end: speech.length),
        duration: const Duration(seconds: 1),
      )..tween(
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
        String text = speech.substring(0, value.get('step'));
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [value.get("color1"), value.get("color2")],
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Align(alignment: Alignment.centerLeft,
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold
                      ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
