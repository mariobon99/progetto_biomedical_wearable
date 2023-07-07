import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progetto_wearable/database/entities/entities.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/services/impactService.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'package:progetto_wearable/utils/placeToVisit.dart';
import 'package:progetto_wearable/widgets/customSnackBar.dart';
import 'package:provider/provider.dart';
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
  double? _placeLatitude = 45.409284;
  double? _placeLongitude = 11.878336;
  double? _distanceInKM;
  double? _rewardDistance;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _completed = false;

  @override
  void initState() {
    _setPlaceFromSP();
    _getSelectedPlaceCoordinates();
    //_getRewardPosition();
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      _updateDistance(position);
      if (_distanceInKM! < 0.01) {
        _endActivity();
      }
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
    Place? selected =
        await Provider.of<DatabaseRepository>(context, listen: false)
            .findPlaceByName(selectedPlace!);
    setState(() {
      _placeLatitude = selected!.latitude;
      _placeLongitude = selected.longitude;
    });
    Position currentPosition = await Geolocator.getCurrentPosition();
    final double distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      _placeLatitude!,
      _placeLongitude!,
    );
    if (sp.getDouble('reward distance') == null) {
      await sp.setDouble('reward distance', distance / 1000);
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


  void _endActivity() async {
    final sp = await SharedPreferences.getInstance();
    int placeId = sp.getInt('selected place id')!;
    double rewardDistance = sp.getDouble('reward distance')!;
    VisitedPlace visitedPlace = VisitedPlace(null, 0, placeId, rewardDistance);
    sp.remove('selected place');
    sp.remove('selected place id');
    sp.remove('reward distance');
    _setPlaceFromSP();
    setState(() {
      _completed = true;
    });
    Provider.of<DatabaseRepository>(context, listen: false)
        .updateUserDistance(0, rewardDistance);
    Provider.of<DatabaseRepository>(context, listen: false)
        .insertVisitedPlace(visitedPlace);
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
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
                              sp.remove('reward distance');
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
                child: showPlace && !_completed
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
                            style: TextStyle(
                                color: Palette.mainColor, fontSize: 15),
                          ),
                        ],
                      )
                    : Text(
                        'No treasure selected, choose one',
                        style: TextStyle(fontSize: 20),
                      ),
              )),
          ElevatedButton(
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                int placeId = sp.getInt('selected place id')!;
                double reward = sp.getDouble('reward distance')!;
                VisitedPlace visitedPlace =
                    VisitedPlace(null, 0, placeId, reward);
                sp.remove('selected place');
                sp.remove('selected place id');
                sp.remove('reward distance');
                _setPlaceFromSP();
                setState(() {
                  _completed = true;
                });
                Provider.of<DatabaseRepository>(context, listen: false)
                    .updateUserDistance(0, reward);
                Provider.of<DatabaseRepository>(context, listen: false)
                    .insertVisitedPlace(visitedPlace);
                CustomSnackBar(
                    context: context,
                    message: 'Well done! You got to destination!');
              },
              child: Text('Mark as completed')),
        ],
      ),
    );
  }
}
