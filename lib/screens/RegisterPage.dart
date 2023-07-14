import 'dart:math';

import 'package:flutter/material.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/screens/LoginPage.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'package:progetto_wearable/widgets/customSnackBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/database/entities/entities.dart';
import 'package:username_generator/username_generator.dart';

import '../utils/placeToVisit.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);

  static const routename = 'Register';
  final usernameController = TextEditingController();
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  void clearText() {
    usernameController.clear();
    passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    void addRandomUsersToDatabase(int n) {
      for (var i = 1; i < n; i++) {
        var username = UsernameGenerator().generateRandom();
        var distance = (Random().nextDouble() * 200);
        var level = distance < 100
            ? distance < 10
                ? 1
                : 2
            : 3;
        User user = User(i, username, '1234', 'generico', level, distance);

        Provider.of<DatabaseRepository>(context, listen: false)
            .insertUser(user);
      }
    }

    return Scaffold(
        backgroundColor: Palette.bgColor,
        appBar: AppBar(
          title: Text(RegisterPage.routename),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Palette.mainColorShade,
                    border: Border.all(color: Palette.mainColor),
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Please fill all the fields:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(50, 20, 50, 0),
                        child: TextFormField(
                           validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username ';
                              }
                              return null;
                            },
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
                          validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email ';
                              }
                              return null;
                            },
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
                           validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                else{
                                  String error = "";
                                  if (value.length < 8) {
                                    error = 'Please enter at least 8 characters\n';
                                  } 
                                  if (!(value.contains(RegExp(r'[a-z]')))) {
                                    error += "Please enter at least one lowercase letter\n";
                                  }
                                  if (!(value.contains(RegExp(r'[A-Z]')))) {
                                    error += "Please enter at least one uppercase letter\n";
                                  }
                                  if (!(value.contains(RegExp(r'[0-9]')))) {
                                    error += "Please enter at least one number\n";
                                  }
                                  if (!(value.contains(RegExp(r'[!@#%^$&*()?:{}|<>]')))) {
                                    error += "Please enter at least:\n !, @, #, %, ^, \$, &, *, (, ), ?, :, {, }, |, <, >";
                                  }
                                  if(error.isNotEmpty){
                                    return error.toString();    
                                  }
                                  else{
                                    return null;
                                  }
                                }
                          },
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
                          validator:  (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password ';
                              } else if (passwordController.text!=passwordController2.text){
                                return 'The the two passwords don\'t match';
                              }
                              return null;
                            },
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
                            children: const [
                              Icon(
                                Icons.app_registration_outlined,
                                size: 15,
                                //color: Colors.white,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Register',
                              )
                            ],
                          ),
                          onPressed: () async {
                            
                            if (_formKey.currentState!.validate()) {
                              //salvo username, password email nelle shared preferences
                              final sp = await SharedPreferences.getInstance();
                              await sp.setString(
                                  'username', usernameController.text.trim());
                              await sp.setString(
                                  'password', passwordController.text.trim());
                              await sp.setString(
                                  'email', mailController.text.trim());
                              // inserting new user
                              User user = User(
                                  0,
                                  usernameController.text,
                                  mailController.text,
                                  1,
                                  0);
                
                              await Provider.of<DatabaseRepository>(context,
                                      listen: false)
                                  .insertUser(user);
                
                              // inserting the list of visitable places into the db
                              List allplaces = Locations().allplaces;
                              for (int i = 0; i < allplaces.length; i++) {
                                Place place = Place(
                                    i,
                                    allplaces[i]['name'],
                                    allplaces[i]['latitudine'],
                                    allplaces[i]['longitudine'],
                                    allplaces[i]['image'],
                                    allplaces[i]['description'],
                                    false);
                                await Provider.of<DatabaseRepository>(context,
                                        listen: false)
                                    .insertPlace(place);
                              }
                              addRandomUsersToDatabase(30);
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()));
                            
                            }

                            

                       
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
