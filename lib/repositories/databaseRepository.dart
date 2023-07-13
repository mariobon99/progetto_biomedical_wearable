import 'package:flutter/material.dart';
import 'package:progetto_wearable/database/database.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

class DatabaseRepository extends ChangeNotifier {
  final AppDatabase database;

  DatabaseRepository({required this.database});
  // User queries
  Future<void> insertUser(User user) async {
    await database.usersDao.insertUser(user);
    notifyListeners();
  }

  Future<List<User>> findAllUsers() async {
    final users = await database.usersDao.findAllUsers();
    return users;
  }

  Future<User?> findUserById(int id) async {
    final user = await database.usersDao.findUserById(id);
    return user;
  }

  Future<double?> findUserDistance(int id) async {
    final distance = await database.usersDao.findUserDistance(id);
    return distance;
  }

  Future<int?> findUserLevel(int id) async {
    final distance = await database.usersDao.findUserLevel(id);
    return distance;
  }

  Future<void> updateUserDistance(int id, double amount) async {
    await database.usersDao.updateUserDistance(id, amount);
    notifyListeners();
  }

  Future<void> updateUserLevel(int id, int newLevel) async {
    await database.usersDao.updateUserLevel(id, newLevel);
    notifyListeners();
  }

  Future<void> deleteUser(int id) async {
    await database.usersDao.deleteUser(id);
    notifyListeners();
  }

  Future<void> updateUserUsername(int id, String newUsername) async {
  await database.usersDao.updateUserUsername(id, newUsername);
  notifyListeners();
  }

  Future<void> updateUserEmail(int id, String newEmail) async {
  await database.usersDao.updateUserEmail(id, newEmail);
  notifyListeners();
  }

  // Places queries

  Future<List<Place>> findAllPlaces() async {
    List<Place> places = await database.placesDao.findAllPlaces();
    return places;
  }

  Future<Place?> findPlaceByName(String name) async {
    Place? place = await database.placesDao.findPlaceByName(name);
    return place;
  }

  Future<void> insertPlace(Place place) async {
    await database.placesDao.insertPlace(place);
    notifyListeners();
  }

  Future<List<Place>?> findUsermadePlaces() async {
    final listPlaces = database.placesDao.findUsermadePlaces();
    return listPlaces;
  }

  // VisitedPlace queries
  Future<List<VisitedPlace>> findAllVisitedPlaces() async {
    final places = await database.visitedPlacesDao.findAllVisitedPlaces();
    return places;
  }

  Future<void> deleteVisitedPlace(int id) async {
    await database.visitedPlacesDao.deleteVisitedPlace(id);
    notifyListeners();
  }

  Future<void> insertVisitedPlace(VisitedPlace visitedPlace) async {
    await database.visitedPlacesDao.insertVisitedPlace(visitedPlace);
    notifyListeners();
  }

  Future<int?> findVisitedPlacesByUser(int idUser) async {
    final visitedPlaces =
        await database.visitedPlacesDao.findVisitedPlacesByUser(idUser);
    return visitedPlaces;
  }

  Future<List<VisitedPlace>?> findAllPlacesByAUser(int idUser) async {
    return await database.visitedPlacesDao.findAllPlacesByAUser(idUser);
  }
}