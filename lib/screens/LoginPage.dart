import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/LoginImpactPage.dart';
import 'package:progetto_wearable/screens/MainPagewithNavBar.dart';
import 'package:progetto_wearable/screens/RegisterPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/services/impactService.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
    final tokenManager = TokenManager();

    return Scaffold(
        appBar: AppBar(
          title: Text(LoginPage.routename),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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

                    //tento di prendere il refresh dalle shared preferences,se non c'è allora mi ritorna null
                    final refresh= sp.getString('refresh');
                    final access= sp.getString('access'); //Debug: usato per vedere se dopo 5 min quando access scatudo mi rimanda al login impact
                    print(refresh);
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
                        if(access == null){
                          //primo accesso dell'utente, nelle shared preferences non c'è salvato il refresh
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  LoginImpactPage()));
                        } else {
                          //refresh salvato, controllo se valido
                           if(JwtDecoder.isExpired(access as String)){
                              //se refresh scaduto lo rimando al login impact in cui poi viene generato nuono JWT
                              Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  LoginImpactPage()));
                           } else {
                            // refresh valido lo mando a home
                            Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainPage()));
                           }
                        }
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
                    await sp.remove('access');
                    await sp.remove('refresh');
                  },
                  child: Text('DEBUG:Empty shared preferences'))
            ],
          ),
        ));
  }
}
