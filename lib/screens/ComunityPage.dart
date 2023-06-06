import 'package:flutter/material.dart';
import 'package:line_icons/line_icon.dart';
import 'package:line_icons/line_icons.dart';
import 'package:progetto_wearable/utils/palette.dart';

class CommunityPage extends StatelessWidget {
  CommunityPage({Key? key}) : super(key: key);

  String get routename => 'Useful advice';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 1000,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Palette.bgColor, Palette.tertiaryColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Text(
              'Hello',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Container(
            color: Palette.tertiaryColor,
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => Card(
                elevation: 5,
                child: Dismissible(
                  key: UniqueKey(),
                  background: Container(color: Palette.tertiaryColor),
                  secondaryBackground: Container(color: Palette.black),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                    title: Text('${(index + 1) * 200}'),
                    trailing: LineIcon(LineIcons.alternateArrowCircleUp),
                    iconColor: index % 2 == 0 ? Colors.red : Colors.lightGreen,
                    tileColor: (index + 1) * 200 <= 500
                        ? Palette.mainColor
                        : Color.fromARGB(255, 214, 214, 214),
                  ),
                  onDismissed: (direction) {},
                ),
              ),
            ),
          ),
        ),
      ],
    );
  } //buil
} //ProfilePage