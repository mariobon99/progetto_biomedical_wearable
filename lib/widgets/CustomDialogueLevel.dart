import 'package:flutter/material.dart';

import '../utils/palette.dart';

class CustomAlert extends StatelessWidget {
  String title;
  String imagePath;
  String description;

  CustomAlert({required this.title, required this.imagePath, required this.description});
  

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Container(
        height: 450,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Palette.black,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Palette.white,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Container(
                    color: Palette.tertiaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            description,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'OK!',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
