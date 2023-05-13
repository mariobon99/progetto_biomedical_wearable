import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progetto_wearable/screens/EditProfilePage.dart';
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

  /*var _image;
  var imagePicker;
  var type;

  @override
  void initState() {
    super.initState();
    imagePicker = ImagePicker();
  }*/

  @override
  void initState() {
    super.initState();
    loadSavedValues();
  }

  Future<void> loadSavedValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username');
      password = prefs.getString('password');
      age = prefs.getInt('age');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('$routename')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /*SizedBox(
                height: 52,
              ),
              Center(
                child: GestureDetector(
                  onTap: () async {
                    var source = ImageSource.camera;
          
                    XFile image = await imagePicker.pickImage(
                        source: source,
                        imageQuality: 50,
                        preferredCameraDevice: CameraDevice.front);
                    setState(() {
                      _image = File(image.path);
                    });
                  },
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(color: Colors.red[200]),
                    child: _image != null
                        ? CircleAvatar(
                          radius: 90.0,
                          
                          child: Image.file(
                              _image,
                              width: 200.0,
                              height: 200.0,
                              fit: BoxFit.fill,
                            ),
                        )
                        : Container(
                            decoration: BoxDecoration(color: Colors.red[200]),
                            width: 200,
                            height: 200,
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.grey[800],
                            ),
                          ),
                  ),
                ),
              ),*/
              Text("Username",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24 )),
              Text("$username",style: TextStyle(fontSize: 20, color: Colors.grey)),
              SizedBox(height: 20),
              imageProfile(),
              SizedBox(height: 20),
              Text("Email",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17 )),
              Text("marzia@gmail.com",style: TextStyle(color:Colors.grey)), //email da implementare
              SizedBox(height: 5),
              Text("Age",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17 )),
              Text("$age",style: TextStyle(color:Colors.grey)),
              SizedBox(height: 5),
              Text("Level",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17 )),
              Text("1",style: TextStyle(color:Colors.grey)), //da implementare
              SizedBox(height: 5),
              Text('Password: $password'), // da togliere, solo per far vedere che va
               Row(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.center,
                children:[
                  IconButton(
                    // iconSize: 72,
                    onPressed: (){}, 
                    icon: const Icon(Icons.auto_awesome)),
                const Text("Your reward",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17 )),
        ],
        ),
          
        ElevatedButton(
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

  
  Widget imageProfile(){
  return Stack(
    children: <Widget>[
      CircleAvatar(
        radius: 80.0,
        backgroundImage: AssetImage("assets/images/user.png")

        ),
      
      Positioned(
        bottom: 20.0,
        right: 20.0,
        child: InkWell(
          //usato InkWell perchè possiede il metodo onTap()
          onTap: (){
            
          },
          child: const Icon(
            Icons.camera_alt, 
            color: Colors.white,
            size: 28.0)
        ),
        ),
    ],
  );
} //imageProfile


} // _ProfilePageState

