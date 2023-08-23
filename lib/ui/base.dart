import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:speech/ui/following/following.dart';
import 'package:speech/ui/myPost/myPost.dart';
import 'package:speech/ui/post/post.dart';
import 'package:speech/ui/notification/notificationIcon.dart';
import 'package:speech/ui/createPost/createPost.dart';
import 'package:speech/ui/profile/profileAvatar.dart';

class BaseScreen extends HookConsumerWidget {
  const BaseScreen({
    Key? key,
  }) : super(key: key);

  void _onChangeIndex({
    required int value,
    required ValueNotifier<int> notifier,
  }) {
    notifier.value = value;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState<int>(0);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: const [
          NotificationIcon(),
          SizedBox(width: 10),
          ProfileAvatar(),
          SizedBox(width: 20),
        ],
      ),
      body: <Widget>[
        const PostScreen(),
        const CreatePostScreen(),
        const FollowingScreen(),
        const MyPostScreen(),
      ].elementAt(selectedIndex.value),

      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.grey.shade50,
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
          child: GNav(
              haptic: true, // haptic feedback
              tabBorderRadius: 15,
              curve: Curves.easeIn, // tab animation curves
              duration: const Duration(milliseconds: 500), // tab animation duration
              gap: 8, // the tab button gap between icon and text
              color: Colors.grey[800], // unselected icon color
              activeColor: Colors.purpleAccent, // selected icon and text color
              iconSize: 24, // tab button icon size
              tabBackgroundColor: Colors.purple.withOpacity(0.1), // selected tab background color
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), // navigation bar padding
              tabs: const [
                GButton(
                  icon: CupertinoIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.create_outlined,
                  text: 'Post',
                ),
                GButton(
                  icon: CupertinoIcons.person_2,
                  text: 'Following',
                ),
                GButton(
                  icon: CupertinoIcons.person,
                  text: 'My post',
                )
              ]
          ),
        ),
      ),
    );
  }
}
