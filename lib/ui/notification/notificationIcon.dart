import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NotificationIcon extends ConsumerWidget {
  const NotificationIcon({
    Key? key,
  }) : super(key: key);

  void _onTap(BuildContext context) {}

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = 554;
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Stack(
        children: [
          SizedBox(
            width: count > 10 ? 50 : 30,
            height: 100,
            child: const Icon(
              CupertinoIcons.bell,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Text(
              count > 0
                  ? count > 99
                      ? "99+"
                      : count.toString()
                  : "",
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
