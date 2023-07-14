import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progetto_wearable/screens/screens.dart';
import 'package:progetto_wearable/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/widgets/widgets.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const routename = 'Profile';

  String? username;
  String? password;
  String? email;

  File? _image;
  var imagePicker;

  int Userlevel = 1;

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
      email = prefs.getString('email');
      if (prefs.getString('image') != null) {
        _image = File(prefs.getString('image')!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseRepository>(builder: (context, dbr, child) {
      return FutureBuilder(
          future: dbr.findUserLevel(0),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Userlevel = snapshot.data as int;
              return Scaffold(
                backgroundColor: Palette.bgColor,
                appBar: AppBar(
                  title: const Text('$routename'),
                  actions: <Widget>[
                    IconButton(
                        onPressed: () {
                          openDialog(context).then((value) async {
                            // Aggiorna i dati quando si torna da Edit Profile
                            loadSavedValues();
                            //Debug, verifica che i valori siano stati aggiornati nel database
                            //User? user = await Provider.of<DatabaseRepository>(context,
                            //listen: false)
                            //.findUserById(0);
                            //print(user?.username);
                            //print(user?.email);
                          });
                        },
                        icon: const Icon(Icons.edit))
                  ],
                ),
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
                                      padding: const EdgeInsets.only(
                                          top: 70,
                                          bottom: 0,
                                          left: 10,
                                          right: 10),
                                      child: Column(
                                        children: <Widget>[
                                          const Text("Username",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text("$username"),
                                          const SizedBox(height: 20),
                                          const Text("Email",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text("$email"),
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
                          subtitle: Text('Level: $Userlevel'),
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
                          onTap: () {
                            if (Userlevel == 1) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomAlert(
                                    title: Levels.title1,
                                    imagePath: Levels.imagePath1,
                                    description: Levels.description1,
                                  );
                                },
                              );
                            }
                            if (Userlevel == 2) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomAlert(
                                    title: Levels.title2,
                                    imagePath: Levels.imagePath2,
                                    description: Levels.description2,
                                  );
                                },
                              );
                            }
                            if (Userlevel == 3) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return CustomAlert(
                                    title: Levels.title3,
                                    imagePath: Levels.imagePath3,
                                    description: Levels.description3,
                                  );
                                },
                              );
                            }
                          },
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
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => AchievmentsPage()));
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    });
  }

  Widget _imageProfile() {
    return Stack(children: <Widget>[
      CircleAvatar(
        radius: 82.0,
        backgroundColor: Palette.black,
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
              color: Palette.mainColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt,
              color: Palette.white,
            ),
          ),
        ),
      ),
    ]);
  } //imageProfile
} // _ProfilePageState
