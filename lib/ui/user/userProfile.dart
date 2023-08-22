import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/constants/constants.dart';
import 'package:speech/model/userModel.dart';
import 'package:speech/provider/authProviders/authProvider.dart';
import 'package:speech/provider/uploadImageProvider.dart';
import 'package:speech/provider/userProvider.dart';
import 'package:speech/ui/user/userProfileAvatar.dart';
import 'package:speech/ui/user/userProfileSetting.dart';
import 'package:speech/ui/widgets/dialogs.dart';
import 'package:speech/ui/widgets/uploadImage.dart';

class UserProfileScreen extends ConsumerWidget {
  final UserModel user;

  const UserProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  _onProfileSetting(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserProfileSetting(),
      ),
    );
  }

  _onLogOut(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);
    await ref.read(authStateProvider.notifier).deleteToken();
    ref.read(authStateProvider.notifier).checkAuthState();
  }

  _tile({
    required BuildContext context,
    required WidgetRef ref,
    required VoidCallback onTap,
    required IconData iconData,
    required String text,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(iconData),
      title: Text(
        text,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          _ProfileWithBackgroundImage(innerBoxIsScrolled: innerBoxIsScrolled),
        ];
      },
      body: ListView(
        children: [
          _tile(
            context: context,
            ref: ref,
            onTap: () => _onProfileSetting(context),
            iconData: CupertinoIcons.gear,
            text: "Profile",
          ),
          _tile(
            context: context,
            ref: ref,
            onTap: () => _onLogOut(context, ref),
            iconData: CupertinoIcons.power,
            text: "Log out",
          ),
        ],
      ),
    ));
  }
}

class _ProfileWithBackgroundImage extends ConsumerWidget {
  final bool innerBoxIsScrolled;

  const _ProfileWithBackgroundImage({
    Key? key,
    required this.innerBoxIsScrolled,
  }) : super(key: key);

  _onBackgroundChange(BuildContext context, WidgetRef ref) async {
    Navigator.pop(context);

    final images = ref.read(uploadImageStateProvider).images;

    if (images.isEmpty) {
      Dialogs.toast(
          context: context,
          message: "please provide image",
          buttonText: "close");
      return;
    }

    final response = await ref
        .read(userStateProvider.notifier)
        .changeBackgroundImage(image: images.first);

    if (!response && context.mounted) {
      Dialogs.toast(
        context: context,
        message: "There seems to be a problem",
        buttonText: "Close",
      );
    }
  }

  _onProfileImageChange(BuildContext context, WidgetRef ref) {
    Navigator.pop(context);
    final images = ref.read(uploadImageStateProvider).images;

    if (images.isEmpty) {
      Dialogs.toast(
          context: context,
          message: "Please provide image",
          buttonText: "Close");
      return;
    }
  }

  _changeImage({
    required BuildContext context,
    required WidgetRef ref,
    bool forBackgroundImage = false,
  }) {
    ref.read(uploadImageStateProvider.notifier).remove();
    Dialogs.bottomSheet(
        context: context,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload image",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const UploadImage(),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => forBackgroundImage
                    ? _onBackgroundChange(context, ref)
                    : _onProfileImageChange(context, ref),
                child: Text(
                  "Upload",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            )
          ],
        ));
  }

  Widget _profileImage({
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const UserProfileAvatar(radius: 80, isClickable: false),
          Positioned(
            bottom: 0,
            child: IconButton(
              onPressed: () => _changeImage(context: context, ref: ref),
              icon: const Icon(Icons.edit, color: Colors.white, size: 30),
            ),
          )
        ],
      ),
    );
  }

  @override
  SliverAppBar build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStateProvider).user.first;
    final backgroundImageUrl = "${Constants.IMAGEURL}${user.backgroundUrl}";

    return SliverAppBar(
      backgroundColor: Colors.purple.shade300,
      expandedHeight: 250.0,
      floating: true,
      pinned: true,
      snap: true,
      iconTheme: const IconThemeData(color: Colors.white),
      forceElevated: innerBoxIsScrolled,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          user.name,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),
        background: Container(
          decoration: BoxDecoration(
            color: user.backgroundUrl == null ? Colors.purple.shade300 : null,
            image: user.backgroundUrl == null
                ? null
                : DecorationImage(
                    image: NetworkImage(backgroundImageUrl),
                    fit: BoxFit.cover,
                  ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _profileImage(context: context, ref: ref),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => _changeImage(
                    context: context,
                    ref: ref,
                    forBackgroundImage: true,
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white, size: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
