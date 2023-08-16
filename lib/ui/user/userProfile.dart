import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:speech/model/userModel.dart';
import 'package:speech/provider/authProviders/authProvider.dart';
import 'package:speech/ui/user/userProfileAvatar.dart';
import 'package:speech/ui/user/userProfileSetting.dart';

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
            builder: (context) => UserProfileSetting(user: user)));
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
          _ProfileWithBackgroundImage(
            innerBoxIsScrolled: innerBoxIsScrolled,
            user: user,
          ),
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
  final UserModel user;

  const _ProfileWithBackgroundImage({
    Key? key,
    required this.innerBoxIsScrolled,
    required this.user,
  }) : super(key: key);

  _onBackgroundChange() {}

  _onProfileImageChange() {}

  _profileImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          const UserProfileAvatar(radius: 80),
          Positioned(
            bottom: 0,
            child: IconButton(
              onPressed: () => _onProfileImageChange(),
              icon: const Icon(Icons.edit, color: Colors.white, size: 30),
            ),
          )
        ],
      ),
    );
  }

  @override
  SliverAppBar build(BuildContext context, WidgetRef ref) {
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
                : DecorationImage(image: NetworkImage(user.backgroundUrl!)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _profileImage(),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => _onBackgroundChange(),
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
