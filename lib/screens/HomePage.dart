import 'package:flutter/material.dart';
import 'package:progetto_wearable/services/impactService.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  //static const routename = 'HomePage';
  String get routename => 'Homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget? place;
  bool showPlace = false;

  @override
  void initState() {
    _setPlaceFromSP();
    super.initState();
  }

  void _setPlaceFromSP() async {
    final sp = await SharedPreferences.getInstance();
    String? placeName = sp.getString('selected place');
    if (placeName != null) {
      setState(() {
        showPlace = true;
        place = Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Palette.mainColorShade),
            height: 150,
            width: 250,
            child: Center(
                child: Column(
              children: [
                CircularProgressIndicator(
                  color: Palette.mainColor,
                ),
                SizedBox(
                  height: 20,
                ),
                FittedBox(
                  child: Text('$placeName in progress',
                      style: TextStyle(
                        fontSize: 30,
                        color: Palette.black,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  'Click to stop',
                  style: TextStyle(color: Palette.mainColor, fontSize: 20),
                )
              ],
            )));
      });
    } else {
      setState(() {
        place = Text('No place selected. Choose one');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onTap: () {
            if (showPlace) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Stop activity?'),
                  content: Text(
                      'The current activity will be stopped before completion. No points will be gained. Continue?'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          final sp = await SharedPreferences.getInstance();
                          sp.remove('selected place');
                          _setPlaceFromSP();
                          Navigator.of(context).pop();
                        },
                        child: const Text('Yes')),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'))
                  ],
                ),
              );
            }
          },
          child: place),
    );
  }
}
