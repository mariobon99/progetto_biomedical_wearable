import 'package:flutter/material.dart';
import 'widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:provider/provider.dart';

final TextEditingController usernameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController emailController = TextEditingController();

final _formKey = GlobalKey<FormState>();

Future<void> saveUsername(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
}

Future<void> savePassword(String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('password', password);
}

Future<void> saveEmail(String email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', email);
}

void clearText() {
  usernameController.clear();
  passwordController.clear();
  emailController.clear();
}

Future openDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Edit your profile',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                usernameTextField(),
                const SizedBox(
                  height: 8.0,
                ),
                passwordTextField(),
                const SizedBox(
                  height: 8.0,
                ),
                emailTextField(),
                const SizedBox(
                  height: 16.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);

                        // Azzera i controller dei campi di testo
                        clearText();
                      },
                      child: const Text(
                        'CANCEL',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          //Aggiornare shared preferences
                          await saveUsername(usernameController.text);
                          await savePassword(passwordController.text);
                          await saveEmail(emailController.text);

                          //Aggiornare i valori nel database
                          await Provider.of<DatabaseRepository>(context,
                                  listen: false)
                              .updateUserUsername(0, usernameController.text);
                          await Provider.of<DatabaseRepository>(context,
                                  listen: false)
                              .updateUserEmail(0, emailController.text);
                          // ignore: use_build_context_synchronously

                          Navigator.pop(context);

                          // Azzera i controller dei campi di testo
                          usernameController.clear();
                          passwordController.clear();
                          emailController.clear();

                          // ignore: use_build_context_synchronously
                          CustomSnackBar(
                              context: context,
                              message: 'Your edits have been saved!');
                        } //if
                      },
                      child: const Text(
                        'SAVE',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        )));

//widget -----------------------------------------------------------------
Widget usernameTextField() {
  return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your new username or cancel';
        }
        return null;
      },
      controller: usernameController,
      enabled: true,
      decoration: const InputDecoration(helperText: 'Enter your new username'),
      autofocus: true);
} //usernameTextField

Widget passwordTextField() {
  return TextFormField(
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'Please enter your password or cancel';
      } else {
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
          error +=
              "Please enter at least: !, @, #, %, ^, \$, &, *, (, ), ?, :, {, }, |, <, >";
        }
        if (error.isNotEmpty) {
          return error.toString();
        } else {
          return null;
        }
      }
    },
    controller: passwordController,
    enabled: true,
    decoration: const InputDecoration(helperText: 'Enter your new password'),
    autofocus: true,
    obscureText: true,
  );
} // passwordTextField

Widget emailTextField() {
  return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your new email or cancel';
        }
        return null;
      },
      controller: emailController,
      enabled: true,
      decoration: const InputDecoration(helperText: 'Enter your new email'),
      autofocus: true);
} //emailTextField