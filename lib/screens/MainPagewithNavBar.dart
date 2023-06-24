import 'package:flutter/material.dart';
import 'screens.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:progetto_wearable/utils/utils.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  List<String> titles = ['Home', 'Place finder', 'Useful advices', 'Community'];
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.bgColor,
      appBar: AppBar(
        title: Text(titles[_selectedIndex]),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(LineIcons.userCircle),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => ProfilePage())));
            },
          ),
        ],
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          const HomePage(),
          PlacePage(
            onPageChange: (index) {
              setState(() {
                _selectedIndex = index;
                pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              });
            },
          ),
          const AdvisePage(),
          CommunityPage()
        ],
      ),
      drawer: Drawer(
          child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Palette.mainColor,
                    image: DecorationImage(
                        image: AssetImage('assets/images/drawer_image.jpg'),
                        fit: BoxFit.fill,
                        opacity: 0.8),
                  ),
                  child: const DrawerHeader(
                    child: Text(
                      'Sustainable Padua',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ListTile(
                    title: const Text('Profile'),
                    trailing: const Icon(LineIcons.userCircle),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(),
                          ));
                    }),
                ListTile(
                    title: const Text('Logout'),
                    trailing: const Icon(Icons.logout),
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginPage(),
                          ));
                    }),
                ListTile(
                  title: const Text('Settings'),
                  trailing: const Icon(Icons.settings),
                  onTap: () {},
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.bottomCenter,
              child: Text('Version 1.0 powered by MND Group\u00AE')),
          SizedBox(
            height: 20,
          )
        ],
      )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Palette.mainColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Palette.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Palette.mainColorShade,
              color: Palette.white,
              tabs: const [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.mapMarked,
                  text: 'Places',
                ),
                GButton(
                  icon: LineIcons.questionCircle,
                  text: 'Advices',
                ),
                GButton(
                  icon: LineIcons.users,
                  text: 'Community',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                  pageController.animateToPage(index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.ease);
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
