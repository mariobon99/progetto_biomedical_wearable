import 'package:floor/floor.dart';
import 'package:progetto_wearable/database/entities/entities.dart';

@Entity(
  foreignKeys: [
    ForeignKey(
      childColumns: ['idUser'],
      parentColumns: ['id'],
      entity: User,
    ),
    ForeignKey(
        childColumns: ['idPlace'],
        parentColumns: ['id'],
        entity: Place,
        onDelete: ForeignKeyAction.setNull)
  ],
)
class VisitedPlace {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int idUser;
  final int idPlace;
  final double? distance;

  //Default constructor
  VisitedPlace(this.id, this.idUser, this.idPlace, this.distance);
}//VisitedPlace