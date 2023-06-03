import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/activity.dart';
import '../services/impactService.dart';

class AdvisePage extends StatefulWidget {
  const AdvisePage({super.key});

  @override
  State<AdvisePage> createState() => _AdvisePageState();
}

class _AdvisePageState extends State<AdvisePage> {
  double? mean;

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
            },
            child: Text('GET DATA'),
          ),
          ElevatedButton(
              onPressed: () async {
                final sp = await SharedPreferences.getInstance();
                sp.remove('distance');
                setState(() {});
              },
              child: Text('Remove mean distance')),
          FutureBuilder(
              future: SharedPreferences.getInstance(),
              builder: ((context, snapshot) {
                if (snapshot.hasData) {
                  final sp = snapshot.data as SharedPreferences;
                  var mean = sp.getDouble('distance');
                  if (mean != null) {
                    return Text(
                        'Media delle ultime due settimane: ${mean.toStringAsFixed(2)} km');
                  } else {
                    return Text('Scarica i dati');
                  }
                } else {
                  return CircularProgressIndicator();
                }
              }))
        ],
      ),
    ));
    ;
  }
}

double computeMean(List<Activity> result) {
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
