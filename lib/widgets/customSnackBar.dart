import 'package:flutter/material.dart';
import 'package:progetto_wearable/utils/palette.dart';

ScaffoldMessengerState CustomSnackBar(
    {required BuildContext context, required String message}) {
  return ScaffoldMessenger.of(context)
    ..clearSnackBars()
    ..showSnackBar(SnackBar(
      backgroundColor: Palette.mainColorShade,
      content: Text(
        message,
        style: const TextStyle(fontSize: 15, color: Palette.black),
      ),
      duration: const Duration(seconds: 2),
    ));
}
