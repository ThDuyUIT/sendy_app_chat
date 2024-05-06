import 'dart:ui';

import 'package:flutter/material.dart';

class AppSnackbar{
  void buildSnackbar(
      BuildContext context, String content, Color background, Color textColor) {
    var snackBar = SnackBar(
        backgroundColor: background,
        content: Text(
          content,
          style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold),
        ));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}