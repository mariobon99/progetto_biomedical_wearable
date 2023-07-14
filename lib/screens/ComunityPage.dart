import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'package:progetto_wearable/widgets/customSnackBar.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

class CommunityPage extends StatelessWidget {
  CommunityPage({Key? key}) : super(key: key);

  String get routename => 'Community';

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

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseRepository>(builder: (context, dbr, child) {
      return FutureBuilder(
          future: dbr.findAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as List<User>;
              return Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                          //color: Palette.mainColorShade,
                          border:
                              Border.all(color: Palette.mainColor, width: 2),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              ImageIcon(
                                AssetImage("assets/images/medal.png"),
                                color: Palette.black,
                                size: 30,
                              ),
                              Text(
                                'LEADERBOARD',
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'century'),
                              ),
                              ImageIcon(
                                AssetImage("assets/images/medal.png"),
                                color: Palette.black,
                                size: 30,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Container(
                        decoration: BoxDecoration(
                            //color: Palette.mainColorShade,
                            border: Border.all(color: Palette.mainColor),
                            borderRadius: BorderRadius.all(Radius.circular(4))),
                        child: ListView.builder(
                            padding: const EdgeInsets.all(5),
                            itemCount: data.length,
                            itemBuilder: (context, userIndex) {
                              final user = data[userIndex];
                              final isOnPodium = userIndex < 3;
                              return Card(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4)),
                                    color: chooseColor(userIndex, user),
                                  ),
                                  height: isOnPodium ? 100 : 80,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(3, 8, 3, 8),
                                    child: ListTile(
                                        onTap: () {
                                          if (user.id != 0) {
                                            showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Add ${user.username} to your friends'),
                                                    actions: [
                                                      TextButton(
                                                          onPressed: () {
                                                            CustomSnackBar(
                                                                context:
                                                                    context,
                                                                message:
                                                                    'Available in the next uptdate');
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('Yes')),
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text('No'))
                                                    ],
                                                  );
                                                });
                                          }
                                        },
                                        tileColor: user.id == 0
                                            ? Palette.tertiaryColor
                                            : Palette.mainColorShade,
                                        title: FittedBox(
                                          alignment: Alignment.centerLeft,
                                          fit: BoxFit.scaleDown,
                                          child: Text(
                                            '${userIndex + 1}. ${user.id == 0 ? 'You' : user.username}',
                                            style: TextStyle(
                                                fontSize: isOnPodium ? 23 : 22,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              'User level: ${user.level}',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Palette.black),
                                            ),
                                            Text(
                                                'Total distance: ${user.distance.toStringAsFixed(2)} km')
                                          ],
                                        ),
                                        trailing: isOnPodium
                                            ? const Icon(LineIcons.medal)
                                            : null),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          });
    });
  } //buil
}
