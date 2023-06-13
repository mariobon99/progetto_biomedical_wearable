import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'package:progetto_wearable/utils/palette.dart';
import 'package:provider/provider.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

class CommunityPage extends StatelessWidget {
  CommunityPage({Key? key}) : super(key: key);

  String get routename => 'Useful advice';

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseRepository>(builder: (context, dbr, child) {
      return FutureBuilder(
          future: dbr.findAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data as List<User>;
              return ListView.builder(
                  padding: EdgeInsets.all(5),
                  itemCount: data.length,
                  itemBuilder: (context, userIndex) {
                    final user = data[userIndex];
                    return Container(
                      padding: EdgeInsets.all(2),
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
                        tileColor: Palette.mainColorShade,
                        title: Text(
                          user.username,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('User level: ${user.level}'),
                      ),
                    );
                  });
            } else {
              return CircularProgressIndicator();
            }
          });
    });
  } //buil
} //ProfilePage