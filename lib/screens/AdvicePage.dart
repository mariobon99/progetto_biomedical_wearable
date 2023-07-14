import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:provider/provider.dart';
import '../database/entities/entities.dart';
import '../utils/utils.dart';
import '../widgets/customSnackBar.dart';

// class AdvisePage extends StatefulWidget {
//   const AdvisePage({super.key});
//   String get routename => 'Useful advice';

//   @override
//   State<AdvisePage> createState() => _AdvisePageState();
// }

// class _AdvisePageState extends State<AdvisePage> {
//   double? mean;
//   int? _visited;
//   List<VisitedPlace> visitedPlaces = [];
//   int level = 0;
//   List<Place> places = [
//     Place(0, 'aaa', 20, 30, 'ajsjs'),
//     Place(0, 'aaa', 20, 30, 'ajsjs'),
//     Place(0, 'aaa', 20, 30, 'ajsjs'),
//     Place(0, 'aaa', 20, 30, 'ajsjs')
//   ];

//   List<FlSpot>? graph_dots;

//   @override
//   void initState() {
//     getVisitedPlaceByUser();
//     super.initState();
//   }

//   void addRandomUsersToDatabase(int n) {
//     for (var i = 1; i < n; i++) {
//       var username = UsernameGenerator().generateRandom();
//       var distance = (Random().nextDouble() * 200);
//       var level = distance < 100
//           ? distance < 10
//               ? 1
//               : 2
//           : 3;
//       User user = User(i, username, '1234', 'generico', level, distance);

//       Provider.of<DatabaseRepository>(context, listen: false).insertUser(user);
//     }
//   }

//   void getVisitedPlacesNumber() async {
//     int? visited = await Provider.of<DatabaseRepository>(context, listen: false)
//         .findVisitedPlacesByUser(0);
//     setState(() {
//       _visited = visited;
//     });
//   }

//   Future<void> getVisitedPlaceByUser() async {
//     final places = await Provider.of<DatabaseRepository>(context, listen: false)
//         .findAllPlacesByAUser(0);
//     List<FlSpot> spotlist = [];
//     for (var i = 0; i < places!.length; i++) {
//       spotlist.add(FlSpot(places[i].id!.toDouble(), places[i].distance!));
//       print(places[i].id);
//       print(places[i].distance);
//     }
//     setState(() {
//       graph_dots = spotlist;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final tokenManager = TokenManager();

//     return SingleChildScrollView(
//         child: Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: SizedBox(
//               height: 250,
//               child: LineChart(
//                 LineChartData(
//                     lineBarsData: [
//                       LineChartBarData(
//                           spots: graph_dots,

//                           // Add more data points if needed

//                           // Customize line appearance
//                           colors: [Colors.blue, Colors.green],
//                           isCurved: true,
//                           barWidth: 4,
//                           dotData: FlDotData(show: true)),
//                     ],
//                     titlesData: FlTitlesData(show: false),
//                     backgroundColor: Colors.grey[900]),
//               ),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: () async {
//               final sp = await SharedPreferences.getInstance();
//               final result = await tokenManager.requestData() as List<Activity>;
//               double meanDistance = computeMean(result);
//               sp.setDouble('distance', meanDistance);
//               int userLevel =
//                   await Provider.of<DatabaseRepository>(context, listen: false)
//                           .findUserLevel(0) ??
//                       0;

//               setState(() {
//                 mean = meanDistance;
//                 level = userLevel;
//               });
//             },
//             child: Text('GET DATA'),
//           ),
//           ElevatedButton(
//               onPressed: () async {
//                 final sp = await SharedPreferences.getInstance();
//                 sp.remove('distance');
//                 setState(() {
//                   mean = null;
//                   level = 0;
//                 });
//               },
//               child: Text('Remove mean distance')),
//           Text(mean == null
//               ? 'Get data'
//               : 'Mean distance: ${mean!.toStringAsFixed(2)} km'),
//           Text('User level = $level'),
//           Text('Posti visitati: $_visited'),
//           ElevatedButton(
//               onPressed: () {
//                 addRandomUsersToDatabase(20);
//               },
//               child: Text('Add users')),
//           ElevatedButton(
//               onPressed: () {
//                 getVisitedPlacesNumber();
//               },
//               child: Text('Get visited places')),
//           ElevatedButton(
//               onPressed: () async {
//                 var listPlaces = await Provider.of<DatabaseRepository>(context,
//                         listen: false)
//                     .findAllPlaces();
//                 setState(() {
//                   places = listPlaces;
//                 });
//               },
//               child: Text('places')),
//           Text('${places}'),
//           ElevatedButton(
//               onPressed: () async {
//                 var listPlaces = await Provider.of<DatabaseRepository>(context,
//                         listen: false)
//                     .findAllVisitedPlaces();
//                 setState(() {
//                   visitedPlaces = listPlaces;
//                 });
//               },
//               child: Text('visited places')),
//           Text('$visitedPlaces'),
//           ElevatedButton(
//               onPressed: () async {
//                 int userLevel = await Provider.of<DatabaseRepository>(context,
//                             listen: false)
//                         .findVisitedPlacesByUser(0) ??
//                     0;
//                 print("Il livello è: $userLevel");
//                 double distance = await Provider.of<DatabaseRepository>(context,
//                             listen: false)
//                         .findUserDistance(0) ??
//                     0;
//                 print("La distanza è: $distance");
//                 int n_visited_places = await Provider.of<DatabaseRepository>(
//                             context,
//                             listen: false)
//                         .findVisitedPlacesByUser(0) ??
//                     0;
//                 print("I posti visitati sono: $n_visited_places");
//                 int current_level = checkLevel(distance, n_visited_places);

//                 if (current_level > userLevel) {
//                   print("Devi aggiornare il livello\n");
//                   //aggiornare livello dal database
//                 }
//               },
//               child: Text('Prova database per livelli'))
//         ],
//       ),
//     ));
//     ;
//   }
// }

// double computeMean(List<Activity>? result) {
//   double somma = 0;
//   double totalValidActivities = 0;
//   for (var i = 0; i < result!.length; i++) {
//     if (result[i].finalDistance > 0) {
//       somma += result[i].finalDistance;
//       totalValidActivities += 1;
//     }
//   }
//   return somma / totalValidActivities;
// }

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  File? _image;
  final imageLink =
      'https://static.vecteezy.com/ti/vettori-gratis/p3/5065038-mappa-e-icona-segnaletica-direzione-di-viaggio-luogo-sulla-mappa-segnato-con-simbolo-puntatore-mappa-piatta-destinazione-e-icona-segnaletica-illustratore-modificabile-a-colori-gratuito-vettoriale.jpg';
  void clearText() {
    nameController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Palette.mainColor),
                  color: Palette.mainColorShade),
            child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10,),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Here you can insert your favorite spots of Padua and write a brief description to share with the community', style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  const SizedBox(height: 20,),
                  const SizedBox(
                    width: 350,
                    child: Image(
                        fit: BoxFit.contain,
                        isAntiAlias: false,
                        filterQuality: FilterQuality.high,
                        image: AssetImage('assets/images/scorcio.jpg')),
                  ),
                  //const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextFormField(
                      controller: nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your new email or cancel';
                                }
                                return null;
                              },
                              enabled: true,
                              decoration: const InputDecoration(
                                  helperText: 'Enter the place name'),
                              autofocus: true
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: TextFormField(
                      controller: descriptionController,
                              enabled: true,
                              decoration: const InputDecoration(
                                  helperText:
                                      'Write a brief description of the place'),
                              autofocus: true
                    ),
                  ),
                  const SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            var source = ImageSource.camera;
                  
                             XFile image = await ImagePicker().pickImage(
                                source: source,
                                imageQuality: 50,
                                preferredCameraDevice:
                                    CameraDevice.front) as XFile;
                  
                                setState(() {
                                  setState(() {
                                    _image = File(image.path);
                                  });
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: const BoxDecoration(
                                  color: Palette.mainColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Palette.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Add a photo of the place'),
                          ],
                        ),
                  ),
                  const SizedBox(height: 30,),
                ],
            ),
          ),
        ),
      ),
      /*Consumer<DatabaseRepository>(
        builder: (context, dbr, child) {
          return FutureBuilder(
              future: dbr.findUsermadePlaces(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return Center(
                      child: Text('Add some new place'),
                    );
                  } else {
                    final listplaces = snapshot.data as List<Place>;
                    return ListView.builder(
                      itemCount: listplaces.length,
                      padding: EdgeInsets.all(4),
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Palette.mainColor,
                                Palette.mainColorShade
                              ]),
                              borderRadius: BorderRadius.circular(5)),
                          child: ListTile(
                            title: Text('${listplaces[index].name}'),
                            subtitle: Text('${listplaces[index].description}'),
                            trailing: Image.network(
                              listplaces[index].imageLink,
                            ),
                            tileColor: Palette.mainColorShade,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        },
      )*/
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
       splashColor: Colors.deepOrange,
        onPressed: () async {
            final position =await Geolocator.getCurrentPosition();
              final latitude = position.latitude;
              final longitude = position.longitude;
                Place newPlace = Place(
                                null,
                                nameController.text,
                                latitude,
                                longitude,
                                imageLink,
                                descriptionController.text,
                                true);
                clearText();
                await Provider.of<DatabaseRepository>(context,
                        listen: false)
                    .insertPlace(newPlace);
            if(nameController.text=="" || nameController.text==""){
                CustomSnackBar(context: context, message: 'Fill all fields');
            }//if
                            
            },
          /*showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text('Insert your new place name and description'),
                    content: SizedBox(
                      height: 200,
                      child: Column(children: [
                        TextFormField(
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your new email or cancel';
                              }
                              return null;
                            },
                            enabled: true,
                            decoration: const InputDecoration(
                                helperText: 'Enter the place name'),
                            autofocus: true),
                        TextFormField(
                            controller: descriptionController,
                            enabled: true,
                            decoration: const InputDecoration(
                                helperText:
                                    'Write a brief description of the place'),
                            autofocus: true),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                var source = ImageSource.camera;

                                XFile image = await ImagePicker().pickImage(
                                    source: source,
                                    imageQuality: 50,
                                    preferredCameraDevice:
                                        CameraDevice.front) as XFile;

                                setState(() {
                                  setState(() {
                                    _image = File(image.path);
                                  });
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.all(5.0),
                                decoration: const BoxDecoration(
                                  color: Palette.mainColor,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Palette.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Text('Add a photo of the place'),
                          ],
                        ),
                      ]),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            final position =
                                await Geolocator.getCurrentPosition();
                            final latitude = position.latitude;
                            final longitude = position.longitude;
                            Place newPlace = Place(
                                null,
                                nameController.text,
                                latitude,
                                longitude,
                                imageLink,
                                descriptionController.text,
                                true);
                            clearText();
                            await Provider.of<DatabaseRepository>(context,
                                    listen: false)
                                .insertPlace(newPlace);
                            Navigator.pop(context);
                          },
                          child: Text('Add')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancel')),
                    ],
                  ));
                  */

        child: Icon(Icons.add_location_rounded),
      ),
    );
  }
}
