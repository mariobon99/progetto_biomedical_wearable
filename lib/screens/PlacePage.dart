import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/utils/utils.dart';
import 'dart:async';
import 'dart:io';
import 'package:progetto_wearable/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/entities/entities.dart';
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

  // default radius if the user doesn't allow IMPACT data to be used
  double? meanDistance = 3;

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

  // Determine the GPS permission
  Future<LocationPermission?> _determinePermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    return permission;
  }

  // opens the app settings for enable GPS
  Future<void> _openGPSSettings() async {
    await Geolocator.openAppSettings();
  }

  // determines the actual position
  Future<void> _determinePosition() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentUserPosition = position;
    });
  }

  // computes the distance of all the places
  void _getTheDistance() async {
    await _determinePosition();
    var listPlaces =
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

  // gets the FITBIT data calling the IMPACT server and computes the radius of visitable places
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

  // algorithm to compute from the IMPACT data the mean distance of the activities
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

  // creates the tile with the place infos
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
            // dialog to start activity
            // ignore: use_build_context_synchronously
            showDialog(
                context: context,
                builder: (context) {
                  return condition
                      ? AlertDialog(
                          title: FittedBox(
                              child: Text('Start activity: ${place.name} ?')),
                          content: place.userMade
                              ? Text('${place.description}\nContinue?')
                              : Text(
                                  '${place.name} ${place.description}  Continue?'),
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
                      ? [Palette.tertiaryColor, Palette.mainColorShade]
                      : [Palette.darkGrey, Palette.grey]),
              borderRadius: BorderRadius.circular(5),
              border: place.userMade
                  ? Border.all(color: Colors.orange, width: 2)
                  : null),
          height: 100,
          child: Row(
            children: [
              const SizedBox(
                width: 5,
              ),
              CircleAvatar(
                radius: 44,
                backgroundColor: Palette.white,
                backgroundImage: const AssetImage('assets/images/logo.png'),
                foregroundImage: place.imageLink.contains('http')
                    ? Image.network(
                        place.imageLink,
                        fit: BoxFit.cover,
                      ).image
                    : Image.file(
                        File(place.imageLink),
                        fit: BoxFit.cover,
                      ).image,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Text(
                          place.name!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Palette.white,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.location_on),
                        Text(
                          "${distance.toStringAsFixed(2)} KM Away",
                          style: const TextStyle(
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
                      const Text(
                        'In order to our app to run,\n enable the GPS permission in your local app settings',
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            _openGPSSettings();
                            _changePage();
                          },
                          child: const Text('Enable GPS'))
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
