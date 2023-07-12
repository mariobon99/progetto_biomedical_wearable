import 'package:floor/floor.dart';

@Entity(tableName: 'Place')
class Place {
// id is the PRIMARY KEY for the table Place
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String? name;

// latitude of the place
  final double latitude;

// longitude of the place
  final double longitude;

  final String imageLink;
  final bool userMade;
  final String description;

  //Default constructor
  Place(this.id, this.name, this.latitude, this.longitude, this.imageLink,
      this.description, this.userMade);
} //Place
