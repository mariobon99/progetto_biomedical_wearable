import 'package:floor/floor.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

@dao
abstract class PlacesDao {
  //Query that allows to obrain all the Places in the table
  @Query('SELECT * FROM Place')
  Future<List<Place>> findAllPlaces();

  // Query that allows to obtain the place with the given name
  @Query('SELECT * FROM Place WHERE name= :name')
  Future<Place?> findPlaceByName(String name);

  //Query that allows to insert a new Place in the table
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPlace(Place place);

  //Query that allows to delete a Place from the table
  @delete
  Future<void> deleteExposure(Place place);

//Query that allows to update a Place
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updatePlace(Place place);

  @Query('SELECT * FROM Place WHERE userMade = true')
  Future<List<Place>?> findUsermadePlaces();

  @Query('SELECT name FROM Place')
  Future<List<String>> getAllPlaceNames();
}
