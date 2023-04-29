import 'package:flutter/material.dart';

class AdvisePage extends StatelessWidget {
  const AdvisePage({Key? key}) : super(key: key);

  static const routename = 'AdvisePage';

  @override
  Widget build(BuildContext context) {
    //print('${CalendarPage.routename} built');
    return Scaffold(
      appBar: AppBar(
        title: Text(AdvisePage.routename),
      ),
      body: Center(
        child: Text('Vari consigli...'),
            ),
        );
  } //build

} //ProfilePage