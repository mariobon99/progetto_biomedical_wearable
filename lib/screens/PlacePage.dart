import 'package:flutter/material.dart';

class PlacePage extends StatelessWidget {
  const PlacePage({Key? key}) : super(key: key);

  static const routename = 'PlacePage';

  @override
  Widget build(BuildContext context) {
    //print('${CalendarPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(PlacePage.routename),
      ),
      body: Center(
        child: Text('Inserire vari posti con distanza'),
            ),
        );
  } //build

} //ProfilePage