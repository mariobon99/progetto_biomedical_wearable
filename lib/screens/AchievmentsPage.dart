import 'package:flutter/material.dart';

import 'package:progetto_wearable/utils/palette.dart';
import 'package:progetto_wearable/utils/levels.dart';

import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:provider/provider.dart';


class AchievmentsPage extends StatefulWidget {
  AchievmentsPage({Key? key}) : super(key: key);

  @override
  _AchievmentsPageState createState() => _AchievmentsPageState();
}

class _AchievmentsPageState extends State<AchievmentsPage> {
  static const routename = 'Your Achievments';
  int Userlevel=1;

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseRepository>(builder: (context, dbr, child) {
      return FutureBuilder(
          future: dbr.findUserLevel(0),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Userlevel = snapshot.data as int;
              return Scaffold(
                backgroundColor: Palette.bgColor,
                appBar: AppBar(
                  title: const Text('$routename'),
                  ),
                body: ListView.builder(
        shrinkWrap: true,
         itemCount: Userlevel,
         itemBuilder: (context, index) {
          int currentLevel=index+1;

          return ListTile(
            leading:Image.asset(
                'assets/images/QRcode$currentLevel.jpeg',
                width: 60,
                height: 60,
                ),
            title: Text('Reward for level $currentLevel',style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Use this QR code to get fantastic discounts at affiliated stores. \nTap to scan!'),
            onTap: (){
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('QR code'),
                    content: Image.asset(
                      'assets/images/QRcode$currentLevel.jpeg',
                      width: 250,
                      height: 250,
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },

          );
        },
                ),
    );
            }else {
              return CircularProgressIndicator();
            }
          }
      );
    });
  }
}