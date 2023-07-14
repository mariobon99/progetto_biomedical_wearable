import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/widgets/customSnackBar.dart';
import 'package:provider/provider.dart';
import '../database/entities/entities.dart';
import '../utils/utils.dart';
import 'dart:io';
import '../widgets/customSnackBar.dart';


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
                    child: Text('Here you can insert your favorite spots of Padua and write a brief description to share with the community', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),textAlign: TextAlign.center,),
                  ),
                  const SizedBox(height: 20,),
                   SizedBox(
                    width: 350,
                     child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                       child: Image(
                           fit: BoxFit.contain,
                           isAntiAlias: false,
                           filterQuality: FilterQuality.high,
                           image: AssetImage('assets/images/scorcio.jpg')),
                     ),
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
                                      'Write a brief description of the place (optional)'),
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
                                    _image =image.path;
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
                            Text('Add a photo of the place'),
                            SizedBox(width: 10,),
                            _image!=null ? 
                            Icon(Icons.done, color: Palette.mainColor,): Container(),
                          ],
                        ),
                  ),
                  const SizedBox(height: 30,),
                ],
            ),
          ),
        ),
      ),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 60,
        width: 120,
        child: FloatingActionButton.extended(
          elevation: 10,
        label: Text('ADD'),
         foregroundColor: Palette.userColor,
         backgroundColor: Palette.mainColorShade,
          onPressed: () async {
              if(nameController.text==""){
                  CustomSnackBar(context: context, message: 'Enter a name to add a place');
                  return;
              }//if
                 
                final Position? position =await Geolocator.getCurrentPosition();
                if(position==null){
                  CustomSnackBar(context: context, message: 'Enable GPS services');
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
                  setState(() {
                    _image=null;
                  });
                  await Provider.of<DatabaseRepository>(context,
                          listen: false)
                      .insertPlace(newPlace);       
              },
           
      
          icon: Icon(Icons.add_location_rounded),
        ),
      ),
    );
  }
}
