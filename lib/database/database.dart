import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

//Here, we are importing the entities and the daos of the database
import 'daos/dao.dart';
import 'entities/entities.dart';

//The generated code will be in database.g.dart
part 'database.g.dart';

//Here we are saying that this is the first version of the Database and it has just 1 entity, i.e., Todo
@Database(version: 1, entities: [User, Place, VisitedPlace])
abstract class AppDatabase extends FloorDatabase {
  //Add all the daos as getters here
  UsersDao get usersDao;
  PlacesDao get placesDao;
  VisitedPlaceDao get visitedPlacesDao;
}//AppDatabase
