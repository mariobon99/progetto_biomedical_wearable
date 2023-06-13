import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/LoginPage.dart';
import 'package:progetto_wearable/screens/MainPagewithNavBar.dart';
import 'package:progetto_wearable/utils/impact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/services/impactService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../widgets/customSnackBar.dart';

//import 'package:flutter_login/theme.dart';

class LoginImpactPage extends StatelessWidget {
  LoginImpactPage({Key? key}) : super(key: key);

  static const routename = 'IMPACT Login';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> saveUsernameImpact(String usernameImpact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('usernameImpact',
        usernameImpact); //save string ('username'=key, username= value)
  }

  Future<void> savePasswordImpact(String passwordImpact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('passwordImpact', passwordImpact);
  }

  void clearText() {
    usernameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tokenManager = TokenManager();

    return Scaffold(
        appBar: AppBar(
          title: Text(LoginImpactPage.routename),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const ClipRRect(
                  child:
                      Image(image: AssetImage('assets/images/ImpactLogo.png')),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      labelText: 'Your IMPACT Username',
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
                      labelText: 'Your IMPACT Password',
                      icon: Icon(Icons.lock),
                    ),
                  ),
                ),
                Container(
                  width: 110,
                  child: ElevatedButton(
                    child: Center(
                      child: Row(
                        children: [
                          Icon(
                            Icons.login,
                            size: 15,
                            //color: Colors.white,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'Authorize',
                          )
                        ],
                      ),
                    ),
                    onPressed: () async {
                      String usernameImpact = usernameController.text;
                      String passwordImpact = passwordController.text;
                      if (usernameImpact != '' && passwordImpact != '') {
                        if (usernameImpact == Impact.username &&
                            passwordImpact == Impact.password) {
                          clearText();
                          tokenManager.getAndStoreTokens();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainPage()));
                        } else {
                          CustomSnackBar(
                              context: context, message: 'Wrong credentials');
                        }
                      } else {
                        CustomSnackBar(
                            context: context,
                            message:
                                'Insert Impact ID and password to authorize');
                      }
                    },
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      final sp = await SharedPreferences.getInstance();
                      await sp.remove('refresh');
                      await sp.remove('access');
                    },
                    child: Text('DEBUG:Empty shared preferences'))
              ],
            ),
          ),
        ));
  }
}
