import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:progetto_wearable/utils/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:progetto_wearable/services/impactService.dart';
import '../widgets/widgets.dart';

class LoginImpactPage extends StatelessWidget {
  LoginImpactPage({Key? key}) : super(key: key);

  static const routename = 'IMPACT Login';
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> saveUsernameImpact(String usernameImpact) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('usernameImpact', usernameImpact);
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
        backgroundColor: Palette.bgColor,
        appBar: AppBar(
          title: const Text(LoginImpactPage.routename),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Palette.mainColor),
                    color: Palette.mainColorShade),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      width: 300,
                      child: Image(
                          fit: BoxFit.contain,
                          isAntiAlias: false,
                          filterQuality: FilterQuality.high,
                          image: AssetImage('assets/images/impact.png')),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'In order to achieve a better experience we would like you to authorize the access to your FitBit data on Impact',
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.center,
                      ),
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
                          icon: const Icon(Icons.person),
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
                          icon: const Icon(Icons.lock),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.app_registration_outlined,
                                size: 15,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Authorize',
                              )
                            ],
                          ),
                        ),
                        onPressed: () async {
                          String usernameImpact =
                              usernameController.text.trim();
                          String passwordImpact =
                              passwordController.text.trim();
                          if (usernameImpact != '' && passwordImpact != '') {
                            final int result =
                                await tokenManager.getAndStoreTokens(
                                    usernameImpact, passwordImpact);
                            if (result == 200) {
                              clearText();

                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MainPage()));
                            } else {
                              CustomSnackBar(
                                  context: context,
                                  message: 'Wrong credentials');
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
                    SizedBox(
                      width: 150,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => MainPage())));
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.app_registration_outlined,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Do not authorize',
                                )
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
