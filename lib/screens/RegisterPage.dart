import 'package:flutter/material.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/screens/LoginPage.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'package:progetto_wearable/widgets/customSnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

import '../utils/placeToVisit.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  static const routename = 'Register';
  final usernameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  void clearText() {
    usernameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.bgColor,
        appBar: AppBar(
          title: Text(RegisterPage.routename),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Text(
                  'Please fill all the fields:',
                  style: TextStyle(fontSize: 18),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                  child: TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      labelText: 'Username',
                      icon: const Icon(Icons.person),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                  child: TextFormField(
                    controller: mailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(90.0),
                      ),
                      labelText: 'E-mail',
                      icon: const Icon(Icons.mail),
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
                      icon: const Icon(Icons.lock),
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
                      icon: const Icon(Icons.lock),
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
                          Icons.app_registration_outlined,
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
                          mailController.text != '' &&
                          passwordController.text != '' &&
                          passwordController.text != '' &&
                          passwordController.text == passwordController2.text) {
                        final sp = await SharedPreferences.getInstance();
                        await sp.setString(
                            'username', usernameController.text.trim());
                        await sp.setString(
                            'password', passwordController.text.trim());
                        await sp.setString('mail', mailController.text.trim());
                        // inserting new user
                        User user = User(0, usernameController.text,
                            passwordController.text, mailController.text, 1, 0);

                        Provider.of<DatabaseRepository>(context, listen: false)
                            .insertUser(user);

                        // inserting the list of visitable places into the db
                        List allplaces = Locations().allplaces;
                        for (int i = 0; i < allplaces.length; i++) {
                          Place place = Place(
                              i,
                              allplaces[i]['name'],
                              allplaces[i]['latitudine'],
                              allplaces[i]['longitudine'],
                              allplaces[i]['image']);
                          await Provider.of<DatabaseRepository>(context,
                                  listen: false)
                              .insertPlace(place);
                        }

                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      } else if (passwordController.text !=
                          passwordController2.text) {
                        CustomSnackBar(
                            context: context,
                            message: 'The two passords are different');
                      } else {
                        CustomSnackBar(
                            context: context, message: 'Fill all fields');
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
