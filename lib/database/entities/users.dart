import 'dart:ffi';

import 'package:floor/floor.dart';

@Entity(tableName: 'User')
class User{

// id is the PRIMARY KEY for the table User
  final int? id;

  final String username;

  final String password;

  final String email;

  //Level of the user in the application
  final int level;

  //Default constructor
  User(this.id, this.username,this.password,this.email, this.level);
} //User