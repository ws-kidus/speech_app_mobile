import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppWidgets {
  static Widget loadingAnimation({double size = 30}) {
    return LoadingAnimationWidget.threeArchedCircle(
      color: Colors.purple,
      size: size,
    );
  }

  static Widget errorMessage({
    String errorText = "There seems to be a problem",
    required BuildContext context,
    required VoidCallback function,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
