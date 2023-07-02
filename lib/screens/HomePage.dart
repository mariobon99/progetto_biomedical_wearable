import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progetto_wearable/services/impactService.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'package:progetto_wearable/utils/placeToVisit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';
import 'package:progetto_wearable/database/entities/entities.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});
  //static const routename = 'HomePage';
  String get routename => 'Homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showPlace = false;
  String? _placeName;
  double? _placeLatitude;
  double? _placeLongitude;
  double? _distanceInKM;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _completed = false;

  @override
  void initState() {
    _setPlaceFromSP();
    _getSelectedPlaceCoordinates();
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      _updateDistance(position);
    }, onError: (error) {
      print(error);
    });
    super.initState();
  }

  @override
  void dispose() {
    _positionStreamSubscription!.cancel();
    super.dispose();
  }

  void _updateDistance(Position currentPosition) {
    final double distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      _placeLatitude!,
      _placeLongitude!,
    );

    setState(() {
      _distanceInKM = distance / 1000;
      if (_distanceInKM! < 0.002) {
        showPlace = false;
        _completed = true;
      }
    });
  }

  void _getSelectedPlaceCoordinates() async {
    final sp = await SharedPreferences.getInstance();
    String? selectedPlace = sp.getString('selected place');
    final locations = Locations().allplaces;
    if (selectedPlace != null) {
      for (var i = 0; i < locations.length; i++) {
        if (locations[i]['name'] == selectedPlace) {
          setState(() {
            _placeLatitude = locations[i]['latitudine'];
            _placeLongitude = locations[i]['longitudine'];
          });
          break;
        }
      }
    }
  }

  void _setPlaceFromSP() async {
    final sp = await SharedPreferences.getInstance();
    String? placeName = sp.getString('selected place');
    setState(() {
      showPlace = (placeName != null);
      _placeName = placeName;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
          onLongPress: () {
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
          child: Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.center,
            height: 200,
            width: 350,
            decoration: BoxDecoration(
                color: Palette.mainColorShade,
                border: Border.all(color: Palette.mainColor),
                borderRadius: BorderRadius.circular(15)),
            child: showPlace
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Palette.mainColor,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      FittedBox(
                        child: Text('$_placeName in progress',
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
                        'Distance: ${_distanceInKM?.toStringAsFixed(2) ?? '-'} km',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Hold to stop',
                        style:
                            TextStyle(color: Palette.mainColor, fontSize: 15),
                      ),
                    ],
                  )
                : Text(
                    'No treasure selected, choose one',
                    style: TextStyle(fontSize: 20),
                  ),
          )),
    );
  }
}
