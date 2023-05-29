import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:progetto_wearable/utils/palette.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key? key}) : super(key: key);

  static const routename = 'CommunityPage';

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) => Card(
        elevation: 5,
        child: Dismissible(
          key: UniqueKey(),
          background: Container(color: Palette.tertiaryColor),
          secondaryBackground: Container(color: Palette.black),
          child: ListTile(
            title: Text('${index + 1}'),
            trailing: LineIcon(LineIcons.alternateArrowCircleUp),
            iconColor: index % 2 == 0 ? Colors.red : Colors.green,
            tileColor: index % 2 == 0
                ? Palette.mainColor
                : Color.fromARGB(255, 214, 214, 214),
          ),
          onDismissed: (direction) {},
        ),
      ),
    );
  } //buil
} //ProfilePage