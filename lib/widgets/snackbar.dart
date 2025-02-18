import 'package:flutter/material.dart';
import 'package:restaurant_app_dicoding/theme/colors.dart';

class CustomSnackbar {
  static void showSnackbar(BuildContext context, String message, {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? errorColor : primaryColor,
      behavior: SnackBarBehavior.floating,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}