import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'dart:async';
import 'package:progetto_wearable/utils/placeToVisit.dart';
import 'package:progetto_wearable/widgets/customSnackBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/entities/entities.dart';
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
  Locations location = Locations();
  List<Place> places = [];
  List distances = [];
  double? meanDistance = 100;
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final imageLink =
      'https://static.vecteezy.com/ti/vettori-gratis/p3/5065038-mappa-e-icona-segnaletica-direzione-di-viaggio-luogo-sulla-mappa-segnato-con-simbolo-puntatore-mappa-piatta-destinazione-e-icona-segnaletica-illustratore-modificabile-a-colori-gratuito-vettoriale.jpg';

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
  Future<LocationPermission?> _determinePermission() async {
    // Test if location services are enabled.
    // bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   // Location services are not enabled don't continue
    //   // accessing the position and request users of the
    //   // App to enable the location services.
    //   print('Location services are disabled.');
    //   return null;
    // }

    LocationPermission permission = await Geolocator.checkPermission();

    return permission;
  }

  Future<void> _openGPSSettings() async {
    await Geolocator.openAppSettings();
    await Geolocator.openLocationSettings();
  }

  Future<void> _determinePosition() async {
// When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    //print("Current Position $position");
    setState(() {
      _currentUserPosition = position;
    });
  }

  void _getTheDistance() async {
    await _determinePosition();
    var listPlaces =
        // ignore: use_build_context_synchronously
        await Provider.of<DatabaseRepository>(context, listen: false)
            .findAllPlaces();
    setState(() {
      places = listPlaces;
      distances = List.filled(places.length,
          0); // done to avoid rendering errors for index range errors
    });
    print(places.length);

    for (int i = 0; i < places.length; i++) {
      double storelat = places[i].latitude;
      double storelng = places[i].longitude;

      double? distance = Geolocator.distanceBetween(
        _currentUserPosition!.latitude,
        _currentUserPosition!.longitude,
        storelat,
        storelng,
      );
      setState(() {
        distances[i] = (distance / 1000);
      });
    }
  }

  Future<void> _getMeanDistance() async {
    final tokenManager = TokenManager();
    final sp = await SharedPreferences.getInstance();
    final result = await tokenManager.requestData() as List<Activity>;
    final level = await Provider.of<DatabaseRepository>(context, listen: false)
        .findUserLevel(0);
    double resultMean;
    if (level == 3) {
      resultMean = double.infinity;
    } else {
      resultMean = computeMean(result) * 0.5 * level!.toDouble();
    }
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

  Widget _placeTile(Place place, double distance) {
    bool condition = distance < (meanDistance!);
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
                              Text('You selected ${place.name}. Continue?'),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  await sp.setString(
                                      'selected place', place.name!);
                                  await sp.setInt(
                                      'selected place id', place.id!);
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
                              'You selected ${place.name}. Your level is too low to select this destination.'),
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
                  place.imageLink,
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
                          place.name!,
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
                          "${distance.toStringAsFixed(2)} KM Away",
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
    return FutureBuilder(
        future: _determinePermission(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final permission = snapshot.data as LocationPermission;
            if (permission == LocationPermission.denied ||
                permission == LocationPermission.deniedForever) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'In order to our app to run,\n enable the GPS permission in your local app settings',
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            _openGPSSettings();
                          },
                          child: Text('Enable GPS'))
                    ]),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                child: ListView.builder(
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      return _placeTile(places[index], distances[index]);
                    }),
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
