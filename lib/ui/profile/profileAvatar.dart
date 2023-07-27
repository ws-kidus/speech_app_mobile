import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ProfileAvatar extends ConsumerWidget {
  const ProfileAvatar({
    Key? key,
  }) : super(key: key);

  void _onTap(BuildContext context) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.teal,
        ),
        child: Text(
          "k".toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
