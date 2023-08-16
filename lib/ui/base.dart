import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:speech/ui/following/following.dart';
import 'package:speech/ui/post/post.dart';
import 'package:speech/ui/notification/notificationIcon.dart';
import 'package:speech/ui/createPost/createPost.dart';
import 'package:speech/ui/user/userProfileAvatar.dart';

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
          UserProfileAvatar(),
          SizedBox(width: 20),
        ],
      ),
      body: <Widget>[
        const PostScreen(),
        const CreatePostScreen(),
        const FollowingScreen(),
      ].elementAt(selectedIndex.value),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => _onChangeIndex(value: value, notifier: selectedIndex),
        currentIndex: selectedIndex.value,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            activeIcon: Icon(CupertinoIcons.house_fill),
            label: "",
            tooltip: "home",
          ),
          BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.add_circled_solid),
              icon: Icon(CupertinoIcons.add_circled),
              label: "",
              tooltip: "post"),
          BottomNavigationBarItem(
              activeIcon: Icon(CupertinoIcons.person_fill),
              icon: Icon(CupertinoIcons.person),
              label: "",
              tooltip: "following"),
        ],
      ),
    );
  }
}

