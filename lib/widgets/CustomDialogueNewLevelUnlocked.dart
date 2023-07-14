import 'package:flutter/material.dart';
import '../utils/utils.dart';

class CustomAlertNewLevel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'New level unlocked!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Palette.black,
              ),
            ),
            const SizedBox(height: 16),
            Image.asset(
              'assets/images/badge.png',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 16),
            Text(
                'Now in your profile, you can find a fun description of your new level, and in the achievements section, you can discover an amazing prize!'),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Ok'))
          ],
        ),
      ),
    );
  }
}
