import 'package:flutter/material.dart';
import 'package:progetto_wearable/screens/LoginPage.dart';
import 'package:progetto_wearable/screens/ProfilePage.dart';
import 'package:progetto_wearable/screens/ComunityPage.dart';
import 'package:progetto_wearable/screens/PlacePage.dart';
import 'package:progetto_wearable/screens/AdvicePage.dart';
import 'package:progetto_wearable/screens/HomePage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<Widget> screens = [
    HomePage(),
    PlacePage(),
    AdvisePage(),
    CommunityPage()
  ];
  List<String> titles = ['Home', 'Place finder', 'Useful advices', 'Community'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => ProfilePage())));
            },
          ),
        ],
      ),
      body: screens[_selectedIndex],
      drawer: Drawer(
          child: ListView(
        children: [
          ListTile(
              title: Text('Profile'),
              trailing: Icon(Icons.person),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ));
              }),
          ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.logout),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ));
              }),
        ],
      )),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Place',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'Advise',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Community',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.lightGreen,
        selectedItemColor: Colors.white,
        selectedIconTheme: IconThemeData(size: 35),
        onTap: (int index) {
          setState(
            () {
              _selectedIndex = index;
            },
          );
        },
      ),
    );
  }
}
