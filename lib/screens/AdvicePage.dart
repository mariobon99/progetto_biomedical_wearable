import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/entities/entities.dart';
import '../database/entities/users.dart';
import '../models/activity.dart';
import '../services/impactService.dart';
import 'package:username_gen/username_gen.dart';

class AdvisePage extends StatefulWidget {
  const AdvisePage({super.key});
  String get routename => 'Useful advice';

  @override
  State<AdvisePage> createState() => _AdvisePageState();
}

class _AdvisePageState extends State<AdvisePage> {
  double? mean;
  int? _visited;
  List<VisitedPlace> visitedPlaces = [];
  int level = 0;
  List<Place> places = [
    Place(0, 'aaa', 20, 30, 'ajsjs'),
    Place(0, 'aaa', 20, 30, 'ajsjs'),
    Place(0, 'aaa', 20, 30, 'ajsjs'),
    Place(0, 'aaa', 20, 30, 'ajsjs')
  ];

  List<FlSpot>? graph_dots;

  @override
  void initState() {
    getVisitedPlaceByUser();
    super.initState();
  }

  void addRandomUsersToDatabase(int n) {
    for (var i = 1; i < n; i++) {
      var username = UsernameGen().generate();
      var distance = (Random().nextDouble() * 200);
      var level = distance < 100
          ? distance < 10
              ? 1
              : 2
          : 3;
      User user = User(i, username, '1234', 'generico', level, distance);

      Provider.of<DatabaseRepository>(context, listen: false).insertUser(user);
    }
  }

  void getVisitedPlacesNumber() async {
    int? visited = await Provider.of<DatabaseRepository>(context, listen: false)
        .findVisitedPlacesByUser(0);
    setState(() {
      _visited = visited;
    });
  }

  Future<void> getVisitedPlaceByUser() async {
    final places = await Provider.of<DatabaseRepository>(context, listen: false)
        .findAllPlacesByAUser(0);
    List<FlSpot> spotlist = [];
    for (var i = 0; i < places!.length; i++) {
      spotlist.add(FlSpot(places[i].id!.toDouble(), places[i].distance!));
      print(places[i].id);
      print(places[i].distance);
    }
    setState(() {
      graph_dots = spotlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokenManager = TokenManager();

    return SingleChildScrollView(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                    lineBarsData: [
                      LineChartBarData(
                          spots: graph_dots,

                          // Add more data points if needed

                          // Customize line appearance
                          colors: [Colors.blue, Colors.green],
                          isCurved: true,
                          barWidth: 4,
                          dotData: FlDotData(show: true)),
                    ],
                    titlesData: FlTitlesData(show: false),
                    backgroundColor: Colors.grey[900]),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final sp = await SharedPreferences.getInstance();
              final result = await tokenManager.requestData() as List<Activity>;
              double meanDistance = computeMean(result);
              sp.setDouble('distance', meanDistance);
              int userLevel =
                  await Provider.of<DatabaseRepository>(context, listen: false)
                          .findUserLevel(0) ??
                      0;

              setState(() {
                mean = meanDistance;
                level = userLevel;
              });
            },
            child: Text('GET DATA'),
          ),
          ElevatedButton(
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                sp.remove('distance');
                setState(() {
                  mean = null;
                  level = 0;
                });
              },
              child: Text('Remove mean distance')),
          Text(mean == null
              ? 'Get data'
              : 'Mean distance: ${mean!.toStringAsFixed(2)} km'),
          Text('User level = $level'),
          Text('Posti visitati: $_visited'),
          ElevatedButton(
              onPressed: () {
                addRandomUsersToDatabase(20);
              },
              child: Text('Add users')),
          ElevatedButton(
              onPressed: () {
                getVisitedPlacesNumber();
              },
              child: Text('Get visited places')),
          ElevatedButton(
              onPressed: () async {
                var listPlaces = await Provider.of<DatabaseRepository>(context,
                        listen: false)
                    .findAllPlaces();
                setState(() {
                  places = listPlaces;
                });
              },
              child: Text('places')),
          Text('${places}'),
          ElevatedButton(
              onPressed: () async {
                var listPlaces = await Provider.of<DatabaseRepository>(context,
                        listen: false)
                    .findAllVisitedPlaces();
                setState(() {
                  visitedPlaces = listPlaces;
                });
              },
              child: Text('visited places')),
          Text('$visitedPlaces'),
        ],
      ),
    ));
    ;
  }
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
