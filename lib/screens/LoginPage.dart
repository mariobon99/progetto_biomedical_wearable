import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/MainPagewithNavBar.dart';
import 'package:progetto_wearable/screens/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/palette.dart';
//import 'package:flutter_login/theme.dart';

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
    return Scaffold(
        backgroundColor: Palette.bgColor,
        appBar: AppBar(
          title: Text(LoginPage.routename),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/app_logo.png',
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
                        'Login',
                      )
                    ],
                  ),
                  onPressed: () async {
                    final sp = await SharedPreferences.getInstance();
                    final username = sp.getString('username');
                    final password = sp.getString('password');
                    if (username == null || password == null) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(const SnackBar(
                          content: Text('Register'),
                          duration: Duration(seconds: 2),
                        ));
                    } else {
                      if (usernameController.text == username &&
                          passwordController.text == password) {
                        clearText();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainPage()));
                      } else {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(const SnackBar(
                            content: Text('Wrong credentials'),
                            duration: Duration(seconds: 2),
                          ));
                      }
                    }
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(const SnackBar(
                          content: Text('Already registered, login'),
                          duration: Duration(seconds: 2),
                        ));
                    }
                  },
                  child: Text(
                    'First time? Register',
                    selectionColor: Colors.blue,
                  ),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    final sp = await SharedPreferences.getInstance();
                    await sp.remove('username');
                    await sp.remove('password');
                  },
                  child: Text('DEBUG:Empty shared preferences'))
            ],
          ),
        ));
  }
}
