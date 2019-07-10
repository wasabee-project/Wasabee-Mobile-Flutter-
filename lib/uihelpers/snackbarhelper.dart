import 'package:flutter/material.dart';

class SnackBarHelper {
  static showSnackBar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
