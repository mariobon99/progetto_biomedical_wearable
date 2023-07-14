import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/widgets/customSnackBar.dart';
import 'package:provider/provider.dart';
import '../database/entities/entities.dart';
import '../utils/utils.dart';
import 'dart:io';

class AddPlacePage extends StatefulWidget {
  const AddPlacePage({super.key});

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? _image;
  final imageLink =
      'https://static.vecteezy.com/ti/vettori-gratis/p3/5065038-mappa-e-icona-segnaletica-direzione-di-viaggio-luogo-sulla-mappa-segnato-con-simbolo-puntatore-mappa-piatta-destinazione-e-icona-segnaletica-illustratore-modificabile-a-colori-gratuito-vettoriale.jpg';
  void clearText() {
    nameController.clear();
    descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DatabaseRepository>(
        builder: (context, dbr, child) {
          return FutureBuilder(
              future: dbr.findUsermadePlaces(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Add some new place'),
                    );
                  } else {
                    final listplaces = snapshot.data as List<Place>;
                    return ListView.builder(
                      itemCount: listplaces.length,
                      padding: const EdgeInsets.all(4),
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
                            trailing: listplaces[index]
                                    .imageLink
                                    .contains('http')
                                ? Image.network(listplaces[index].imageLink)
                                : Image.file(File(listplaces[index].imageLink)),
                            tileColor: Palette.mainColorShade,
                          ),
                        ),
                      ),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.orange,
        backgroundColor: Palette.mainColorShade,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text(
                        'Insert your new place name and description'),
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
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                setState(() {
                                  _image = null;
                                });
                                var source = ImageSource.camera;

                                XFile image = await ImagePicker().pickImage(
                                    source: source,
                                    imageQuality: 50,
                                    preferredCameraDevice:
                                        CameraDevice.front) as XFile;

                                setState(() {
                                  _image = image.path;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5.0),
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
                            const SizedBox(
                              width: 20,
                            ),
                            const Text('Add a photo of the place'),
                          ],
                        ),
                      ]),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () async {
                            final Position? position =
                                await Geolocator.getCurrentPosition();
                            if (position == null) {
                              CustomSnackBar(
                                  context: context,
                                  message: 'Enable GPS services');
                              Navigator.pop(context);
                              return;
                            }
                            if (nameController.text == '') {
                              CustomSnackBar(
                                  context: context,
                                  message:
                                      'Name must be given to enter a new place');
                              Navigator.pop(context);
                              return;
                            }
                            final latitude = position.latitude;
                            final longitude = position.longitude;
                            Place newPlace = Place(
                                null,
                                nameController.text,
                                latitude,
                                longitude,
                                _image ?? imageLink,
                                descriptionController.text,
                                true);
                            clearText();
                            await Provider.of<DatabaseRepository>(context,
                                    listen: false)
                                .insertPlace(newPlace);
                            Navigator.pop(context);
                          },
                          child: const Text('Add')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel')),
                    ],
                  ));
        },
        child: const Icon(Icons.add_location_rounded),
      ),
    );
  }
}
