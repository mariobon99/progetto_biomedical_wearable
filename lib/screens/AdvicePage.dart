import 'dart:math';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/database/daos/dao.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/entities/users.dart';
import '../models/activity.dart';
import '../services/impactService.dart';

import 'package:progetto_wearable/utils/levels.dart';

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
              child: Text('Add users')),
              ElevatedButton(
          onPressed: ()async{
            int userLevel =
                  await Provider.of<DatabaseRepository>(context, listen: false)
                          .findUserLevel(0) ??
                      0;
                      print("Il livello è: $userLevel");
            double distance=  await Provider.of<DatabaseRepository>(context, listen: false)
                          .findUserDistance(0) ??
                      0;
                      print("La distanza è: $distance");
            int n_visited_places =
                  await Provider.of<DatabaseRepository>(context, listen: false)
                          .findNumPlaces(0) ??
                      0;
                      print("I posti visitati sono: $n_visited_places");
            int current_level = checkLevel(distance, 6);

            if(current_level > userLevel){
              print("Devi aggiornare il livello\n");
             //aggiornare livello dal database
            }            
          },
          
          child:Text('Prova database per livelli')
        )
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

/*La funzione checkLevel verifica in che livello si trova l'utente in basa alla distanza percorsa e ai posti visitati*/
int checkLevel(double distance, int n_visited_places){
  if(distance <= 10.0 || n_visited_places <= 3){
    return 1;
  }
  
  if((distance > 10.0 && distance <= 100.0) || (n_visited_places > 3 && n_visited_places <= 7)){
      return 2;
  }

  if (distance > 100.0 && n_visited_places > 7){
      return 3;
  }

  return 1;
}