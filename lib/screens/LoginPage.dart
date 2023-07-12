import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progetto_wearable/utils/utils.dart';
import 'package:progetto_wearable/widgets/customSnackBar.dart';
import 'package:progetto_wearable/widgets/loginImageButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/services/impactService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  static const routename = 'Padova Sostenibile';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void clearText() {
    usernameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tokenManager = TokenManager();

    return Scaffold(
        backgroundColor: Palette.bgColor,
        appBar: AppBar(
          title: Text(LoginPage.routename),
          actions: [
            IconButton(
                onPressed: () async {
                  final sp = await SharedPreferences.getInstance();
                  await sp.remove('username');
                  await sp.remove('password');
                  await sp.remove('access');
                  await sp.remove('refresh');
                },
                icon: Icon(Icons.miscellaneous_services))
          ],
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  height: 200,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      labelText: 'Username',
                      icon: Icon(Icons.person),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      labelText: 'Password',
                      icon: Icon(Icons.lock),
                    ),
                  ),
                ),
                Container(
                  width: 130,
                  height: 50,
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: ElevatedButton(
                    child: Row(
                      children: const [
                        Icon(
                          Icons.login,
                          size: 15,
                          //color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          'Login',
                        )
                      ],
                    ),
                    onPressed: () async {
                      final sp = await SharedPreferences.getInstance();
                      final username = sp.getString('username');
                      final password = sp.getString('password');

                      //prendo il refresh dalle shared preferences, se non c'è allora mi ritorna null
                      final refresh = sp.getString('refresh');
                      //final access= sp.getString('access'); Usato per Debug: usato per vedere se dopo 5 min quando access scatudo mi rimanda al login impact

                      if (username == null || password == null) {
                        CustomSnackBar(context: context, message: 'Register');
                      } else {
                        checkGPSPermission();
                        if (usernameController.text.trim() == username &&
                            passwordController.text == password) {
                          clearText();
                          if (refresh == null) {
                            //primo accesso dell'utente,  non ho ancora nulla nelle shared preferences
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginImpactPage()));
                          } else {
                            //refresh salvato, controllo se valido
                            if (JwtDecoder.isExpired(refresh)) {
                              //se refresh scaduto lo rimando al login impact in cui poi viene generato nuono JWT
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginImpactPage()));
                            } else {
                              // refresh valido lo mando a home
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MainPage()));
                            }
                          }
                        } else {
                          CustomSnackBar(
                              context: context, message: 'Wrong credentials');
                        }
                      }
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () async {
                      final sp = await SharedPreferences.getInstance();
                      final username = sp.getString('username');
                      final password = sp.getString('password');
                      if (username == null || password == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()));
                      } else {
                        CustomSnackBar(
                            context: context,
                            message: 'Already registered, login');
                      }
                    },
                    child: Text(
                      'First time? Register',
                      style: TextStyle(color: Palette.mainColor),
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                Text('Or register with:'),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AlternativeLoginButton(
                        assetImagePath: 'assets/images/google_logo.png'),
                    AlternativeLoginButton(
                        assetImagePath: 'assets/images/apple_logo.png'),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

Future<void> checkGPSPermission() async {
// Test if location services are enabled.
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    print('Location services are disabled.');
    return;
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      print('Location permissions are denied');

      return;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    print(
        'Location permissions are permanently denied, we cannot request permissions.');

    /// open app settings so that user changes permissions
    // await Geolocator.openAppSettings();
    // await Geolocator.openLocationSettings();

    return;
  }
}
