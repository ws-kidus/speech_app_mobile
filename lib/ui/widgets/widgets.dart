import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppWidgets {
  static Widget loadingAnimation({double size = 50}) {
    return LoadingAnimationWidget.inkDrop(
      color: Colors.purple,
      size: size,
    );
  }

  static Widget errorMessage({
    String errorText = "there seems to be a problem",
    required BuildContext context,
    required VoidCallback function,
  }) {
    return Column(
      children: [
        Text(
          errorText,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.red,
              ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: function,
          child: Text(
            "Retry",
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}