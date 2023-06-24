import 'package:flutter/material.dart';
import 'package:progetto_wearable/database/database.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

class DatabaseRepository extends ChangeNotifier {
  final AppDatabase database;

  DatabaseRepository({required this.database});

  Future<void> insertUser(User user) async {
    await database.usersDao.insertUser(user);
    notifyListeners();
  }

  Future<List<User>> findAllUsers() async {
    final users = await database.usersDao.findAllUsers();
    return users;
  }

  Future<double?> findUserDistance(int id) async {
    final distance = await database.usersDao.findUserDistance(id);
    return distance;
  }

  Future<int?> findUserLevel(int id) async {
    final distance = await database.usersDao.findUserLevel(id);
    return distance;
  }
}
