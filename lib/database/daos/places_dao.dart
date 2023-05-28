import 'package:floor/floor.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

@dao
abstract class PlacesDao {
  //Query that allows to obrain all the Places in the table
  @Query('SELECT * FROM Places')
  Future<List<Place>> findAllPlaces();

  //Query that allows to insert a new Place in the table
  @insert
  Future<void> insertPlace(Place place);

  //Query that allows to delete a Place from the table
  @delete
  Future<void> deleteExposure(Place place);

//Query that allows to update a Place
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updatePlace(Place place);
}