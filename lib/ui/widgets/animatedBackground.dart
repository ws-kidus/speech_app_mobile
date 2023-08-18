import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final tween = MovieTween()
      ..tween(
        "color1",
        ColorTween(
          begin: Colors.orangeAccent.shade200.withOpacity(0.2),
          end: Colors.purpleAccent.shade200.withOpacity(0.2),
        ),

        duration: const Duration(seconds: 3),
      ).thenTween(
        "color2",
        ColorTween(
          begin: Colors.greenAccent.shade200.withOpacity(0.2),
          end: Colors.yellowAccent.shade200.withOpacity(0.2),
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
