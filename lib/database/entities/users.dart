import 'dart:ffi';

import 'package:floor/floor.dart';

@Entity(tableName: 'User')
class User {
// id is the PRIMARY KEY for the table User
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String username;

  final String email;

  //Level of the user in the application (possible values: 1,2,3)
  final int level;

  final double distance;

  //Default constructor
  User(this.id, this.username, this.email, this.level,
      this.distance);
} //User