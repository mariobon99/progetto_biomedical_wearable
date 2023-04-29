import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static const routename = 'ProfilePage';

  @override
  Widget build(BuildContext context) {
    //print('${CalendarPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(ProfilePage.routename),
      ),
      body: Center(
        child: Text('Fare qualcosa per il profilo'),
            ),
        );
  } //build

} //ProfilePage