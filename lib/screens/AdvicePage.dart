import 'dart:math';

import 'package:flutter/material.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/entities/users.dart';
import '../models/activity.dart';
import '../services/impactService.dart';

class AdvisePage extends StatefulWidget {
  const AdvisePage({super.key});
  String get routename => 'Useful advice';

  @override
  State<AdvisePage> createState() => _AdvisePageState();
}

class _AdvisePageState extends State<AdvisePage> {
  double? mean;
  int level = 0;

  void addRandomUsersToDatabase(int n) {
    for (var i = 1; i < n; i++) {
      User user = User(i, 'User n° $i', '1234', 'generico', Random().nextInt(4),
          Random().nextDouble() * 500);

      Provider.of<DatabaseRepository>(context, listen: false).insertUser(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokenManager = TokenManager();

    return SingleChildScrollView(
        child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
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
          ElevatedButton(
              onPressed: () {
                addRandomUsersToDatabase(20);
              },
              child: Text('Add users'))
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
