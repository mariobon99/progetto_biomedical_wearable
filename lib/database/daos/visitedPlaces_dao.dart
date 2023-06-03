import 'package:floor/floor.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

@dao 
abstract class VisitedPlaceDao{
  //Query that allows to obrain all the Users in the table
  @Query('SELECT * FROM VisitedPlace')
  Future<List<User>> findAllVisitedPlaces();

  //Query that allows to insert a new User in the table
  @insert
  Future<void> insertVisitedPlace(VisitedPlace visitedPlace);

  //Query that allows to delete a User from the table
  @delete
  Future<void> deleteVisitedPlace(VisitedPlace visitedPlace);

  //Query that allows to update user's data 
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateUVisitedPlace(VisitedPlace visitedPlace);

  //Query that allows to seletc the places visited by a User
  @Query('SELECT idPlace FROM VisitedPlace WHERE idUser=: idUser')
  Stream<VisitedPlace?> findAllPlacesByAUser(int idUser);
}