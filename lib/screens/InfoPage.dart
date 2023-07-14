import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('About this app'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  'Are you willing to experience a more sustainable tourism lifestyle? Do you want to share with friends beatiful places around Padua? This app allows you to do so!\n\nSelect a destination and visit it, gaining CO2 points and unlocking new visitable places. Improve the app by inserting your favourite spots of Padua to share with the community. Challenge your friends and climb the leaderborad!\n\nUnlocking new levels you can also get discounts in some Padua\'s affiliate shops.\n\nThis app uses your fitbit data to enable a better experience and suggest you places to visit according to your style.You can unauthorize the access at any time.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.justify,
                ),
                Expanded(
                  child: Container(
                      alignment: Alignment.bottomCenter,
                      child:
                          const Text('Version 1.0 powered by MND Group\u00AE')),
                ),
              ],
            ),
          ),
        ));
  }
}
