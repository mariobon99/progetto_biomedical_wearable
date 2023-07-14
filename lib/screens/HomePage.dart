import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progetto_wearable/database/entities/entities.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/utils/utils.dart';
import 'package:progetto_wearable/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
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
      if (_distanceInKM! < 0.05) {
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

  // function passed to the Geolocator stream to update the distance to the target place
  void _updateDistance(Position currentPosition) {
    final double distance = Geolocator.distanceBetween(
      currentPosition.latitude,
      currentPosition.longitude,
      _placeLatitude!,
      _placeLongitude!,
    );

    setState(() {
      _distanceInKM = distance / 1000;
    });
  }

  // computes the selected place coordinates
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

  // obtain the selected place from the saved Shared Preferences values
  void _setPlaceFromSP() async {
    final sp = await SharedPreferences.getInstance();
    String? placeName = sp.getString('selected place');
    setState(() {
      showPlace = (placeName != null);
      _placeName = placeName;
    });
  }

  // removes selected place and ends activity, updating the DB
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
      _placeLatitude = null;
      _placeLongitude = null;
    });
    Provider.of<DatabaseRepository>(context, listen: false)
        .updateUserDistance(0, rewardDistance);
    Provider.of<DatabaseRepository>(context, listen: false)
        .insertVisitedPlace(visitedPlace);
    CustomSnackBar(
        context: context, message: 'Well done! You got to destination!');
    _levelUpgrade();
  }

  // checking if the user passed level
  Future<void> _levelUpgrade() async {
    final user = await Provider.of<DatabaseRepository>(context, listen: false)
        .findUserById(0);
    int? visited = await Provider.of<DatabaseRepository>(context, listen: false)
        .findVisitedPlacesByUser(0);
    int newLevel = checkLevel(user!.distance, visited!);
    if (newLevel > user.level) {
      showDialog(context: context, builder: (context) => CustomAlertNewLevel());
      await Provider.of<DatabaseRepository>(context, listen: false)
          .updateUserLevel(0, newLevel);
    }
    setState(() {});
  }

  // creating the points for the graphic
  Future<List<FlSpot>?> getVisitedPlaceByUser() async {
    // SISTEMARE
    final places = await Provider.of<DatabaseRepository>(context, listen: false)
        .findAllPlacesByAUser(0);
    List<FlSpot>? spotlist = [const FlSpot(-1, 0)];
    const CO2ConversionRate = 0.192;
    for (var i = places!.length > 10 ? places.length - 10 : 0;
        i < places.length;
        i++) {
      spotlist
          .add(FlSpot(i.toDouble(), places[i].distance! * CO2ConversionRate));
    }
    if (spotlist.length == 1) {
      return null;
    }
    if (spotlist.length > 10) {
      spotlist.removeAt(0);
      return spotlist;
    }
    return spotlist;
  }

  // function to retrieve user stats from DB
  Future<List<double>> getUserStatistics() async {
    final user = await Provider.of<DatabaseRepository>(context, listen: false)
        .findUserById(0);
    final int? visitedPlaceNum =
        await Provider.of<DatabaseRepository>(context, listen: false)
            .findVisitedPlacesByUser(0);
    // distance to next level
    List<double> statistics = [0, 0, 0];
    final level = user!.level;
    final targetDistance;
    switch (level) {
      case 1:
        targetDistance = 10;
        break;
      case 2:
        targetDistance = 100;
        break;
      case 3:
        targetDistance = 1000;
        break;
      default:
        targetDistance = 10;
    }
    statistics[0] = (user.distance / targetDistance * 100) % 100;
    statistics[1] = visitedPlaceNum?.toDouble() ?? 0;
    statistics[2] = user.distance;
    return statistics;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            // first box with activity in progress
            GestureDetector(
                onDoubleTap: _endActivity,
                onLongPress: () {
                  if (showPlace) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Stop activity?'),
                        content: const Text(
                            'The current activity will be stopped before completion. No points will be gained. Continue?'),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                final sp =
                                    await SharedPreferences.getInstance();
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
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.center,
                  height: 200,
                  decoration: BoxDecoration(
                      color: Palette.mainColorShade,
                      border: Border.all(color: Palette.mainColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: showPlace && !_completed
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Palette.mainColor,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FittedBox(
                              child: Text('$_placeName in progress',
                                  style: const TextStyle(
                                    fontSize: 30,
                                    color: Palette.black,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Text(
                              'Distance: ${_distanceInKM?.toStringAsFixed(2) ?? '-'} km',
                              style: const TextStyle(fontSize: 20),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              'Hold to stop',
                              style: TextStyle(
                                  color: Palette.mainColor, fontSize: 15),
                            ),
                          ],
                        )
                      : const Text(
                          'No place selected, choose one',
                          style: TextStyle(fontSize: 20),
                        ),
                )),
            // second box with the graph of carbon footprint
            FutureBuilder(
                future: getVisitedPlaceByUser(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final graph_dots = snapshot.data as List<FlSpot>;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Palette.mainColorShade,
                            border: Border.all(color: Palette.mainColor),
                            borderRadius: BorderRadius.circular(10)),
                        height: 250,
                        child: LineChart(
                          LineChartData(
                            minY: 0,
                            maxY: 5,
                            lineBarsData: [
                              LineChartBarData(
                                  spots: graph_dots,
                                  colors: [Colors.blue, Colors.green],
                                  isCurved: true,
                                  barWidth: 6,
                                  dotData: FlDotData(
                                    show: true,
                                  )),
                            ],
                            titlesData: FlTitlesData(
                                leftTitles: SideTitles(showTitles: false),
                                topTitles: SideTitles(showTitles: false),
                                bottomTitles: SideTitles(showTitles: false),
                                rightTitles: SideTitles(showTitles: true)),
                            axisTitleData: FlAxisTitleData(
                              bottomTitle: AxisTitle(
                                  titleText: 'Last activities',
                                  showTitle: true,
                                  textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              leftTitle: AxisTitle(
                                  titleText:
                                      'Carbon footprint reduction [kgCO2]',
                                  showTitle: true,
                                  textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold)),
                              topTitle: AxisTitle(
                                  titleText: 'Your Carbon Footprint reduction',
                                  showTitle: true,
                                  textStyle: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                            backgroundColor: Colors.grey[900],
                            borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                    color: const Color(0xff37434d), width: 1)),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Container(
                        height: 100,
                        decoration: BoxDecoration(
                            color: Palette.mainColorShade,
                            border: Border.all(color: Palette.mainColor),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Center(
                          child: Text(
                            'You visited no places, \n start visiting and here will appear your\n carbon footprint reduction',
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  }
                }),
            // third box with user stats
            FutureBuilder(
                future: getUserStatistics(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final stats = snapshot.data as List<double>;
                    return Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Palette.mainColorShade,
                          border: Border.all(color: Palette.mainColor),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Your statistics',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: CircularChart(
                                  percentage: stats[0],
                                  title: 'To next level',
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text('Total kgCO2 saved'),
                                    Container(
                                      height: 100,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${(stats[2] * 0.192).toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Text('Total visited places'),
                                    Container(
                                      height: 100,
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${stats[1].toInt()}',
                                        style: const TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
