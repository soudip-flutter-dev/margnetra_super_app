
import 'package:flutter/material.dart';

class AppPopUp {
  static void show({
    required BuildContext context,
    required Widget child,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: child,
        );
      },
    );
  }

  
}
 