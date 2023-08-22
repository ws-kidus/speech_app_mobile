import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/constants/constants.dart';
import 'package:speech/model/userModel.dart';
import 'package:speech/provider/userProvider.dart';
import 'package:speech/ui/user/userProfile.dart';
import 'package:speech/ui/widgets/widgets.dart';

class UserProfileAvatar extends ConsumerWidget {
  final bool isClickable;
  final double radius;

  const UserProfileAvatar({
    Key? key,
    this.radius = 22,
    this.isClickable = true,
  }) : super(key: key);

  void _onTap(BuildContext context, UserModel user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UserProfileScreen(user: user)),
    );
  }

  Widget _letterProfile({
    required BuildContext context,
    required String text,
  }) {
    return FittedBox(
      child: Text(
        text.toUpperCase(),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: radius * 0.9),
      ),
    );
  }

  Widget _imageProfile({
    required BuildContext context,
    required String text,
    required String imageUrl,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius - 2),
      child: CachedNetworkImage(
        imageUrl: Constants.IMAGEURL + imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => AppWidgets.loadingAnimation(
          color: Colors.white,
        ),
        errorWidget: (context, url, error) => Container(
          padding: const EdgeInsets.all(10),
          child: _letterProfile(context: context, text: text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userStateProvider).userUIState;
    final users = ref.read(userStateProvider).user;

    late Widget body;
    switch (state) {
      case UserUIState.NONE:
      case UserUIState.LOADING:
        body = AppWidgets.loadingAnimation(color: Colors.white);
        break;
      default:
        final user = users.first;
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
      onTap: isClickable ? () => _onTap(context, users.first) : null,
      child: CircleAvatar(
        backgroundColor: Colors.purpleAccent,
        radius: radius,
        child: body,
      ),
    );
  }
}
