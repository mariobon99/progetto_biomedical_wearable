import 'package:floor/floor.dart';

@Entity(tableName: 'Place')
class Place{
// id is the PRIMARY KEY for the table Place
@PrimaryKey(autoGenerate: true)
final int? id; 

// latitude of the place
final String latitude;

// longitude of the place
final String longitude;

  //Default constructor
  Place(this.id, this.latitude, this.longitude);

} //Place
