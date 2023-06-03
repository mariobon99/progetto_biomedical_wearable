import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:progetto_wearable/utils/placeToVisit.dart';


class PlacePage extends StatefulWidget {
  const PlacePage({Key? key}) : super(key: key);

  static const routename = 'PlacePage';

  @override
  PlacePageState createState() =>  PlacePageState();
}

class PlacePageState extends State<PlacePage> {
  Position? _currentUserPosition;
  double? distanceImMeter = 0.0;
  Data data = Data();
  StreamSubscription<Position>? positionStream;


  @override
  void dispose() {
    super.dispose();
    /// don't forget to cancel stream once no longer needed
    positionStream?.cancel();
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
      print('Location permissions are permanently denied, we cannot request permissions.');

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
   _currentUserPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    for (int i = 0; i < data.allplaces.length; i++) {
      double storelat = data.allplaces[i]['latitudine'];
      double storelng = data.allplaces[i]['longitudine'];

      distanceImMeter = await Geolocator.distanceBetween(
        _currentUserPosition!.latitude,
        _currentUserPosition!.longitude,
        storelat,
        storelng,
      );
      var distance = distanceImMeter?.toDouble();

      if (distance != null && distance >1000) {
        data.allplaces[i]['distance'] =(distance /1000);        
      }else {
        data.allplaces[i]['distance'] =(distance!);
      }
      setState(() {});
    }
  }

  @override
  void initState() {
    _getTheDistance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: GridView.builder(
          itemCount: data.allplaces.length,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            return Container(
              color: Colors.lightGreen,
              height: height * 0.9,
              width: width * 0.3,
              child: Column(
                children: [
                  Container(
                    height: height * 0.13,
                    width: width,
                    child: Image.network(
                      data.allplaces[index]['image'],
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    data.allplaces[index]['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.location_on),
                      //if (data.allplaces[index]['distance'] < 1000) 
                      //devo sistemare bene tra metri e chilometri


                      Text(
                        "${data.allplaces[index]['distance'].round()} KM Away",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
