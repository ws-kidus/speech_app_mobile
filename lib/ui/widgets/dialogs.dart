import 'package:flutter/material.dart';

class Dialogs {
  static void bottomSheet({
    required BuildContext context,
    required Widget child,
    bool avoidBottomInsects = false,
  }) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        isScrollControlled: avoidBottomInsects,
        builder: (context) => Padding(
              padding: EdgeInsets.only(
                bottom: avoidBottomInsects
                    ? MediaQuery.of(context).viewInsets.bottom
                    : 0,
              ),
              child: IntrinsicHeight(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey,
                  ),
                  margin: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 15,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 3,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(child: child)
                    ],
                  ),
                ),
              ),
            ));
  }
}