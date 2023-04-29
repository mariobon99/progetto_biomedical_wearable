import 'package:flutter/material.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  static const routename = 'CommunityPage';

  @override
  Widget build(BuildContext context) {
    //print('${CalendarPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(CommunityPage.routename),
      ),
      body: Center(
        child: Text('Fare qualcosa con Community(?)'),
            ),
        );
  } //build

} //ProfilePage