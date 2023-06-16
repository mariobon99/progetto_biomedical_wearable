import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'dart:async';
import 'package:progetto_wearable/utils/placeToVisit.dart';
import 'package:progetto_wearable/widgets/customSnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/activity.dart';
import '../services/impactService.dart';

class PlacePage extends StatefulWidget {
  Function? onPageChange;
  PlacePage({Key? key, required this.onPageChange}) : super(key: key);

  static const routename = 'PlacePage';

  @override
  PlacePageState createState() => PlacePageState();
}

class PlacePageState extends State<PlacePage> {
  Position? _currentUserPosition;
  Locations locations = Locations();
  double? meanDistance = 100000;

  @override
  void initState() {
    super.initState();
    _getMeanDistance();
    _getTheDistance();
  }

  void _changePage() {
    // Call the callback function to switch to page one (index 0)
    widget.onPageChange!(0);
  }

  /// Determine the current position of the device
  Future<void> _determinePosition() async {
    // Test if location services are enabled.
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print('Location services are disabled.');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print(
          'Location permissions are permanently denied, we cannot request permissions.');

      /// open app settings so that user changes permissions
      // await Geolocator.openAppSettings();
      // await Geolocator.openLocationSettings();

      return;
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    print("Current Position $position");
    setState(() {
      _currentUserPosition = position;
    });
  }

  Future<void> _getTheDistance() async {
    await _determinePosition();
    //_currentUserPosition = await Geolocator.getCurrentPosition();

    for (int i = 0; i < locations.allplaces.length; i++) {
      double storelat = locations.allplaces[i]['latitudine'];
      double storelng = locations.allplaces[i]['longitudine'];

      double? distance = Geolocator.distanceBetween(
        _currentUserPosition!.latitude,
        _currentUserPosition!.longitude,
        storelat,
        storelng,
      );
      setState(() {
        locations.allplaces[i]['distance'] = (distance / 1000);
      });
    }
  }

  Future<void> _getMeanDistance() async {
    final tokenManager = TokenManager();
    final sp = await SharedPreferences.getInstance();
    final result = await tokenManager.requestData() as List<Activity>;
    double resultMean = computeMean(result);
    sp.setDouble('distance', resultMean);
    setState(() {
      meanDistance = resultMean;
    });
  }

  double computeMean(List<Activity>? result) {
    double somma = 0;
    double totalValidActivities = 0;
    for (var i = 0; i < result!.length; i++) {
      if (result[i].finalDistance > 0) {
        somma += result[i].finalDistance;
        totalValidActivities += 1;
      }
    }
    return somma / totalValidActivities;
  }

  Widget _placeTile(place) {
    bool condition = place['distance'] < (meanDistance! / 2);
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () async {
          final sp = await SharedPreferences.getInstance();
          bool activityInProgress = sp.getString('selected place') != null;
          if (activityInProgress) {
            CustomSnackBar(
                context: context, message: 'Activity already in progress.');
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return condition
                      ? AlertDialog(
                          title: const Text('Start activity?'),
                          content:
                              Text('You selected ${place['name']}. Continue?'),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  await sp.setString(
                                      'selected place', place['name']);
                                  _changePage();
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Yes')),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('No'))
                          ],
                        )
                      : AlertDialog(
                          title: const Text('Activity not available'),
                          content: Text(
                              'You selected ${place['name']}. Your level is too low to select this destination.'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'))
                          ],
                        );
                });
          }
        },
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: condition
                      ? [Palette.mainColor, Palette.mainColorShade]
                      : [Palette.darkGrey, Palette.grey]),
              borderRadius: BorderRadius.circular(5)),
          height: 100,
          child: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              Container(
                height: 92,
                width: 100,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                child: Image.network(
                  place['image'],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return Center(
                        child: Container(
                            padding: EdgeInsets.all(20),
                            height: 70,
                            width: 70,
                            color: Palette.white,
                            child: CircularProgressIndicator()),
                      );
                    }
                  },
                ),
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          place['name'],
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.location_on),
                        //if (locations.allplaces[index]['distance'] < 1000)
                        //devo sistemare bene tra metri e chilometri

                        Text(
                          "${place['distance'].toStringAsFixed(2)} KM Away",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Palette.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
      child: ListView.builder(
          itemCount: locations.allplaces.length,
          itemBuilder: (context, index) {
            return _placeTile(locations.allplaces[index]);
          }),
    );
  }
}
