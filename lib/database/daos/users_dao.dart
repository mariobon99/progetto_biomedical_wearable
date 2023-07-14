import 'dart:ffi';

import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

@dao
abstract class UsersDao {
  //Query that allows to obrain all the Users in the table
  @Query('SELECT * FROM User ORDER BY distance DESC')
  Future<List<User>> findAllUsers();

  @Query('SELECT * FROM User WHERE id=:id')
  Future<User?> findUserById(int id);

  //Query that allows to insert a new User in the table
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUser(User user);

  //Query that allows to delete a User from the table
  @Query('DELETE FROM User WHERE id = :id')
  Future<void> deleteUser(int id);

  //Query that allows to update user's data
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateUser(User user);

  //Query that allows to select user's average distance
  @Query('SELECT distance FROM User WHERE id=:id')
  Future<double?> findUserDistance(int id);

  //Query that allows to select user's level
  @Query('SELECT level FROM User WHERE id=:id')
  Future<int?> findUserLevel(int id);

  //Query tha allows to update the distance of a user
  @Query('UPDATE User SET distance = distance + :amount WHERE id = :id')
  Future<void> updateUserDistance(int id, double amount);

  //Query tha allows to update the distance of a user
  @Query('UPDATE User SET level = :newLevel WHERE id  = :id')
  Future<void> updateUserLevel(int id, int newLevel);

  //Query that allows to update the username
  @Query('UPDATE User SET username  = :newUsername WHERE id  = :id')
  Future<void> updateUserUsername(int id, String newUsername);

  //Query that allows to update the email
  @Query('UPDATE User SET email  = :newEmail WHERE id  = :id')
  Future<void> updateUserEmail(int id, String newEmail);

}
