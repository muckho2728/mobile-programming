import 'package:flutter/material.dart';

class FocusHelper {
  /// Move focus to next field
  static void moveToNext(
      BuildContext context,
      FocusNode? nextFocus,
      ) {
    if (nextFocus != null) {
      FocusScope.of(context).requestFocus(nextFocus);
    } else {
      FocusScope.of(context).unfocus();
    }
  }

  /// Dismiss keyboard
  static void dismissKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  /// Wrap any screen to auto-dismiss keyboard when tapping outside
  static Widget dismissOnTap({
    required Widget child,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}