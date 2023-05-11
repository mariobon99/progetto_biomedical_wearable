import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/screens/MainPagewithNavBar.dart';
//import 'package:flutter_login/theme.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  static const routename = 'Register';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  void clearText() {
    usernameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(RegisterPage.routename),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
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
                padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
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
                padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                child: TextFormField(
                  controller: passwordController2,
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(90.0),
                    ),
                    labelText: 'Confirm Password',
                    icon: Icon(Icons.lock),
                  ),
                ),
              ),
              Container(
                width: 150,
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
                        'Register',
                      )
                    ],
                  ),
                  onPressed: () async {
                    if (usernameController.text != '' &&
                        passwordController.text != '' &&
                        passwordController.text != '' &&
                        passwordController.text == passwordController2.text) {
                      final sp = await SharedPreferences.getInstance();
                      await sp.setString('username', usernameController.text);
                      await sp.setString('password', passwordController.text);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    } else {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(const SnackBar(
                          content: Text('Wrong credentials'),
                          duration: Duration(seconds: 2),
                        ));
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
