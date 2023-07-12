import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/widgets/customSnackBar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _authorization = false;
  List<String> titles = [
    'Home',
    'Place finder',
    'Add a new place',
    'Community'
  ];
  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void checkImpactAuthorization() async {
    final sp = await SharedPreferences.getInstance();
    bool auth = sp.getString('refresh') != '';
    setState(() {
      _authorization = auth;
    });
  }

  @override
  void initState() {
    checkImpactAuthorization();
    super.initState();
  }

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
          HomePage(),
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
          const AddPlacePage(),
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
                    title: const Text('Impact authorization'),
                    trailing: Switch(
                      value: _authorization,
                      onChanged: (value) async {
                        setState(() {
                          _authorization = value;
                        });
                        if (value) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginImpactPage(),
                                  maintainState: false));
                        } else {
                          final sp = await SharedPreferences.getInstance();
                          await sp.remove('access');
                          await sp.remove('refresh');
                          CustomSnackBar(
                              context: context,
                              message: 'Impact authorization deleted');
                        }
                      },
                    )),
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
                    title: const Text('Delete account'),
                    trailing: const Icon(Icons.delete),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete the account'),
                          content: Text(
                              'Are you sure? All the progresses will be lost. '),
                          actions: [
                            TextButton(
                                onPressed: () async {
                                  final sp =
                                      await SharedPreferences.getInstance();
                                  await sp.clear();
                                  await Provider.of<DatabaseRepository>(context,
                                          listen: false)
                                      .deleteVisitedPlace(0);
                                  await Provider.of<DatabaseRepository>(context,
                                          listen: false)
                                      .deleteUser(0);

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginPage(),
                                      ));
                                },
                                child: Text('Yes, delete')),
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('No'))
                          ],
                        ),
                      );
                    }),
                ListTile(
                  title: const Text('Info'),
                  trailing: const Icon(Icons.info_outline),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InfoPage(),
                        ));
                  },
                ),
              ],
            ),
          ),
          Container(
              alignment: Alignment.bottomCenter,
              child: const Text('Version 1.0 powered by MND Group\u00AE')),
          const SizedBox(
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
                  icon: LineIcons.plusCircle,
                  text: 'Insert',
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
