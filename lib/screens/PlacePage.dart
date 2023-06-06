import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'dart:async';
import 'package:progetto_wearable/utils/placeToVisit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlacePage extends StatefulWidget {
  Function? onPageChange;
  PlacePage({Key? key, required this.onPageChange}) : super(key: key);

  static const routename = 'PlacePage';

  @override
  PlacePageState createState() => PlacePageState();
}

class PlacePageState extends State<PlacePage> {
  Position? _currentUserPosition;
  double? distanceImMeter = 0.0;
  Locations locations = Locations();

  @override
  void dispose() {
    super.dispose();
  }

  void _changePage() {
    // Call the callback function to switch to page one (index 0)
    widget.onPageChange!(0);
  }

  /// Determine the current position of the device
  void _determinePosition() async {
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

  Future _getTheDistance() async {
    _determinePosition();
    _currentUserPosition = await Geolocator.getCurrentPosition();

    for (int i = 0; i < locations.allplaces.length; i++) {
      double storelat = locations.allplaces[i]['latitudine'];
      double storelng = locations.allplaces[i]['longitudine'];

      distanceImMeter = Geolocator.distanceBetween(
        _currentUserPosition!.latitude,
        _currentUserPosition!.longitude,
        storelat,
        storelng,
      );
      var distance = distanceImMeter?.toDouble();

      if (distance != null && distance > 1000) {
        locations.allplaces[i]['distance'] = (distance / 1000);
      } else {
        locations.allplaces[i]['distance'] = (distance!);
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    _getTheDistance();
    super.initState();
  }

  Widget _placeTile(place) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Start activity?'),
              content: Text('You selected ${place['name']}. Continue?'),
              actions: [
                TextButton(
                    onPressed: () async {
                      final sp = await SharedPreferences.getInstance();
                      await sp.setString('selected place', place['name']);
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
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Palette.mainColor, Palette.mainColorShade]),
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
