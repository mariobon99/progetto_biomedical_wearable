import 'package:flutter/material.dart';
import 'package:progetto/screens/ProfilePage.dart';
import 'package:progetto/screens/ComunityPage.dart';
import 'package:progetto/screens/PlacePage.dart';
import 'package:progetto/screens/AdvicePage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const routename = 'HomePage';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyStatefulWidget(),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key});

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _selectedIndex = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget> [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
               Navigator.push(context, MaterialPageRoute(builder: ((context) => ProfilePage())));
              },   
            ),
          ],
         title: Text(HomePage.routename),
       ),
      
      body: Center(
        child: const Text('Fare qualcosa')),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
        backgroundColor: Colors.white60,
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: ((context) => PlacePage())));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: ((context) => AdvisePage())));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: ((context) => CommunityPage())));
              break;
          }
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




