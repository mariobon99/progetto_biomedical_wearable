import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

class CommunityPage extends StatelessWidget {
  CommunityPage({Key? key}) : super(key: key);

  String get routename => 'Community';

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseRepository>(builder: (context, dbr, child) {
      return FutureBuilder(
          future: dbr.findAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as List<User>;
              return ListView.builder(
                  padding: EdgeInsets.all(7),
                  itemCount: data.length,
                  itemBuilder: (context, userIndex) {
                    final user = data[userIndex];
                    final isOnPodium = userIndex < 3;
                    return Card(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: chooseColor(userIndex, user),
                        ),
                        height: isOnPodium ? 100 : 80,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(3, 8, 3, 8),
                          child: ListTile(
                              onTap: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text(
                                          'Total distance: ${user.distance.toStringAsFixed(2)} km'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'))
                                      ],
                                    );
                                  }),
                              tileColor: user.id == 0
                                  ? Palette.tertiaryColor
                                  : Palette.mainColorShade,
                              title: Text(
                                '${userIndex + 1}. ${user.id == 0 ? 'You' : user.username}',
                                style: TextStyle(
                                    fontSize: isOnPodium ? 25 : 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'User level: ${user.level}',
                                    style: TextStyle(
                                        fontSize: 15, color: Palette.black),
                                  ),
                                  Text(
                                      'Total distance: ${user.distance.toStringAsFixed(2)} km')
                                ],
                              ),
                              trailing:
                                  isOnPodium ? Icon(LineIcons.medal) : null),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    });
  } //buil
}

Color chooseColor(int userIndex, User user) {
  switch (userIndex) {
    case 0:
      return Color.fromARGB(255, 255, 213, 0);
    case 1:
      return Color.fromARGB(255, 180, 180, 180);
    case 2:
      return Color.fromARGB(255, 217, 114, 82);
    default:
      return user.id == 0 ? Palette.tertiaryColor : Palette.mainColorShade;
  }
}
