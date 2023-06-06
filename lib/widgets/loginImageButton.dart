import 'package:flutter/material.dart';
import 'package:progetto_wearable/utils/palette.dart';

class AlternativeLoginButton extends StatelessWidget {
  String assetImagePath;

  AlternativeLoginButton({super.key, required this.assetImagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ScaffoldMessenger.of(context)
        ..clearSnackBars()
        ..showSnackBar(const SnackBar(
          content: Text('Available in the next update'),
          duration: Duration(seconds: 2),
        )),
      child: Container(
        width: 80,
        height: 80,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            color: Palette.mainColorShade),
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3), color: Palette.white),
          child: Image.asset(
            assetImagePath,
            fit: BoxFit.fitHeight,
          ),
        ),
      ),
    );
  }
}
