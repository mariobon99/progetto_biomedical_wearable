import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progetto_wearable/screens/EditProfilePage.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const routename = 'Profile';

  String? username;
  String? password;
  int? age;

  File? _image;
  var imagePicker;

  @override
  void initState() {
    super.initState();
    loadSavedValues();
    imagePicker = ImagePicker();
  }

  Future<void> loadSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      password = prefs.getString('password');
      age = prefs.getInt('age');
      if (prefs.getString('image') != null) {
        _image = File(prefs.getString('image')!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bgColor,
      appBar: AppBar(title: const Text('$routename')),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 90.0),
                    width: double.infinity,
                    child: Card(
                      color: Palette.mainColorShade,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 70, bottom: 0, left: 10, right: 10),
                            child: Column(
                              children: <Widget>[
                                const Text("Username",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("$username"),
                                const SizedBox(height: 20),
                                const Text("Email",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Text("marzia@gmail.com"),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _imageProfile(),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text('Your Level'),
                subtitle: const Text('Bradipo'),
                leading: const ImageIcon(
                  AssetImage("assets/images/level-up.png"),
                  color: Palette.black,
                  size: 30,
                ),
                trailing: Icon(Icons.arrow_forward),
                tileColor: Palette.mainColorShade,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text('Your Achievements'),
                leading: const ImageIcon(
                  AssetImage("assets/images/medal.png"),
                  color: Palette.black,
                  size: 30,
                ),
                trailing: Icon(Icons.arrow_forward),
                tileColor: Palette.mainColorShade,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Palette.tertiaryColor),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => EditprofilePage(),
                    ),
                  ).then((value) {
                    // Aggiorna i dati quando si torna da Edit Profile
                    loadSavedValues();
                  });
                },
                child: const Text("Edit Profile"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageProfile() {
    return Stack(children: <Widget>[
      CircleAvatar(
        radius: 82.0,
        backgroundColor: Colors.black,
        child: CircleAvatar(
          radius: 80.0,
          backgroundImage: _image == null
              ? AssetImage("assets/images/screenUser.png")
              : Image.file(
                  _image!,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.cover,
                ).image,
        ),
      ),
      Positioned(
        bottom: 5,
        right: 16,
        child: GestureDetector(
          onTap: () async {
            var source = ImageSource.camera;

            XFile image = await imagePicker.pickImage(
                source: source,
                imageQuality: 50,
                preferredCameraDevice: CameraDevice.front);
            final sp = await SharedPreferences.getInstance();
            await sp.setString('image', image.path);
            setState(() {
              _image = File(image.path);
            });
          },
          child: Container(
            padding: EdgeInsets.all(5.0),
            decoration: const BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ]);
  } //imageProfile
} // _ProfilePageState
