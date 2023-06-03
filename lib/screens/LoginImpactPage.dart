import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/LoginPage.dart';
import 'package:progetto_wearable/screens/MainPagewithNavBar.dart';
import 'package:progetto_wearable/utils/impact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/services/impactService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

//import 'package:flutter_login/theme.dart';

class LoginImpactPage extends StatelessWidget {
  LoginImpactPage({Key? key}) : super(key: key);

  static const routename = 'IMPACT Login';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

   Future<void> saveUsernameImpact(String usernameImpact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('usernameImpact', usernameImpact); //save string ('username'=key, username= value)
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const ClipRRect(
                child: Image(image: AssetImage('assets/images/ImpactLogo.png')),
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
                    await saveUsernameImpact(usernameController.text);
                    await savePasswordImpact(passwordController.text);
                    final sp = await SharedPreferences.getInstance();
                    final usernameImpact = sp.getString('usernameImpact');
                    print('us');
                    print(usernameImpact);
                    print(Impact.username);
                    final passwordImpact = sp.getString('passwordImpact');
                    print('psw');
                    print(passwordImpact);
                    print(Impact.password);
                    if (usernameImpact == null || passwordImpact == null) {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(const SnackBar(
                          content: Text('Please enter your credentials'),
                          duration: Duration(seconds: 2),
                        ));
                    } else {
                      if (tokenManager.isBackendUp()== false){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage()));

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('IMPACT backend is down! Please try later '),
                          duration: Duration(seconds: 2),
                           ),
                        ); //ScaffoldMessenger
                      } else {
                      if (usernameImpact == Impact.username &&
                          passwordImpact == Impact.password) {
                        clearText();
                        tokenManager.getAndStoreTokens();
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
                    }
                  },
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
