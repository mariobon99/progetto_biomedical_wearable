import 'dart:ffi';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

@dao 
abstract class UsersDao{
  //Query that allows to obrain all the Users in the table
  @Query('SELECT * FROM User')
  Future<List<User>> findAllUsers();

  //Query that allows to insert a new User in the table
  @insert
  Future<void> insertUser(User user);

  //Query that allows to delete a User from the table
  @delete
  Future<void> deleteUser(User user);

  //Query that allows to update user's data 
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateUser(User user);

  @Query('SELECT distance FROM User WHERE id=:id')
  Future<Int> findUserDistance();






}