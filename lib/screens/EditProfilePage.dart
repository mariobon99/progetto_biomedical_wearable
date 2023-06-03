import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/palette.dart';

class EditprofilePage extends StatelessWidget {
  EditprofilePage({Key? key}) : super(key: key);

  static const routename = 'Edit Profile';

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'username', username); //save string ('username'=key, username= value)
  }

  Future<void> savePassword(String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('password', password);
  }

  Future<void> saveAge(int age) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('age', age);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bgColor,
      appBar: AppBar(
        title: const Text('$routename'),
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await saveUsername(
                    usernameController.text); // Salva il valore dello username
                await savePassword(
                    passwordController.text); // Salva il valore della password
                await saveAge(int.parse(ageController
                    .text)); // Salva il valore dell'età come intero
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Your edits has been saved'),
                    backgroundColor: Colors.grey,
                  ),
                ); //ScaffoldMessenger
              } //if
            },
            icon: const Icon(Icons.check_rounded),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: ListView(
            children: <Widget>[
              usernameTextField(),
              const SizedBox(height: 20),
              passwordTextField(),
              const SizedBox(height: 20),
              ageTextField(),
            ],
          ),
        ),
      ),
    );
  } //build

//widget -------------------------------------------------------------

  Widget usernameTextField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Username';
        }
        return null;
      },
      controller: usernameController,
      enabled: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.lightGreen),
          borderRadius: BorderRadius.circular(90.0),
        ),
        labelText: 'Username',
        hintText: 'Marzia',
        labelStyle: const TextStyle(color: Colors.lightGreen),
      ),
    );
  } //usernameTextField

  Widget passwordTextField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Password';
        }
        return null;
      },
      controller: passwordController,
      enabled: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.lightGreen),
          borderRadius: BorderRadius.circular(90.0),
        ),
        labelText: 'Password',
        hintText: '123456',
        labelStyle: const TextStyle(color: Colors.lightGreen),
      ),
      obscureText: true,
    );
  } // passwordTextField

  Widget ageTextField() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your age';
        } else if (int.tryParse(value) == null) {
          return 'Please enter an integer valid number';
        }
        return null;
      },
      controller: ageController,
      enabled: true,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(90.0)),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(width: 1, color: Colors.lightGreen),
          borderRadius: BorderRadius.circular(90.0),
        ),
        labelText: 'Age',
        hintText: '23',
        labelStyle: const TextStyle(color: Colors.lightGreen),
      ),
    );
  } // ageTextField
}//EditprofilePage


