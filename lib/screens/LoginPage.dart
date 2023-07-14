import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:geolocator/geolocator.dart';
import 'package:progetto_wearable/utils/utils.dart';
import 'package:progetto_wearable/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/services/impactService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  static const routename = 'PaduaGo!';
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
          title: Text(LoginPage.routename,
              style: TextStyle(
                fontSize: 40,
              )),
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
                      final refresh = sp.getString('refresh');
                      if (username == null || password == null) {
                        CustomSnackBar(context: context, message: 'Register');
                      } else {
                        if (usernameController.text.trim() == username &&
                            passwordController.text == password) {
                          clearText();
                          checkGPSPermission();
                          if (refresh == null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginImpactPage()));
                          } else {
                            if (JwtDecoder.isExpired(refresh)) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginImpactPage()));
                            } else {
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
                  height: 60,
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
                  ],
                ),
                const SizedBox(
                  height: 60,
                ),
                Text(
                  'The custom icons used in this app are provided by flaticon.com',
                  style: TextStyle(color: Palette.grey),
                ),
                SizedBox(
                  height: 1,
                )
              ],
            ),
          ),
        ));
  }
}

Future<void> checkGPSPermission() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }
}
