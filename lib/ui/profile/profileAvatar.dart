import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/constants/constants.dart';
import 'package:speech/provider/userProvider.dart';
import 'package:speech/ui/widgets/widgets.dart';

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({
    Key? key,
  }) : super(key: key);

  void _onTap(BuildContext context) {}

  Widget _letterProfile({
    required BuildContext context,
    required String text,
  }) {
    return Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _imageProfile({
    required BuildContext context,
    required String text,
    required String imageUrl,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => AppWidgets.loadingAnimation(),
        errorWidget: (context, url, error) => Container(
          padding: const EdgeInsets.all(10),
          child: Text(
            text.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userStateProvider).userUIState;

    late Widget body;
    switch (state) {
      case UserUIState.NONE:
      case UserUIState.LOADING:
        body = AppWidgets.loadingAnimation();
        break;
      case UserUIState.ERROR:
        body = _letterProfile(context: context, text: "s");
        break;
      case UserUIState.DONE:
        final user = ref.read(userStateProvider).user.first;
        print("++photo ${user.photoUrl}");
        if (user.photoUrl == null) {
          body = _letterProfile(context: context, text: user.name[0]);
          break;
        }
        body = _imageProfile(
          context: context,
          text: user.name[0],
          imageUrl: user.photoUrl!,
        );
        break;
    }

    return GestureDetector(
      onTap: () => _onTap(context),
      child: CircleAvatar(
        backgroundColor: Colors.purpleAccent,
        radius: 22,
        child: body,
      ),
    );
  }
}
