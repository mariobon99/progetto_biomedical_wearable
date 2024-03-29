// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UsersDao? _usersDaoInstance;

  PlacesDao? _placesDaoInstance;

  VisitedPlaceDao? _visitedPlacesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `username` TEXT NOT NULL, `email` TEXT NOT NULL, `level` INTEGER NOT NULL, `distance` REAL NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Place` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `latitude` REAL NOT NULL, `longitude` REAL NOT NULL, `imageLink` TEXT NOT NULL, `userMade` INTEGER NOT NULL, `description` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `VisitedPlace` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `idUser` INTEGER NOT NULL, `idPlace` INTEGER NOT NULL, `distance` REAL, FOREIGN KEY (`idUser`) REFERENCES `User` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`idPlace`) REFERENCES `Place` (`id`) ON UPDATE NO ACTION ON DELETE SET NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UsersDao get usersDao {
    return _usersDaoInstance ??= _$UsersDao(database, changeListener);
  }

  @override
  PlacesDao get placesDao {
    return _placesDaoInstance ??= _$PlacesDao(database, changeListener);
  }

  @override
  VisitedPlaceDao get visitedPlacesDao {
    return _visitedPlacesDaoInstance ??=
        _$VisitedPlaceDao(database, changeListener);
  }
}

class _$UsersDao extends UsersDao {
  _$UsersDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'email': item.email,
                  'level': item.level,
                  'distance': item.distance
                }),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'email': item.email,
                  'level': item.level,
                  'distance': item.distance
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  @override
  Future<List<User>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User ORDER BY distance DESC',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['username'] as String,
            row['email'] as String,
            row['level'] as int,
            row['distance'] as double));
  }

  @override
  Future<User?> findUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM User WHERE id=?1',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['username'] as String,
            row['email'] as String,
            row['level'] as int,
            row['distance'] as double),
        arguments: [id]);
  }

  @override
  Future<void> deleteUser(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM User WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<double?> findUserDistance(int id) async {
    return _queryAdapter.query('SELECT distance FROM User WHERE id=?1',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [id]);
  }

  @override
  Future<int?> findUserLevel(int id) async {
    return _queryAdapter.query('SELECT level FROM User WHERE id=?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [id]);
  }

  @override
  Future<void> updateUserDistance(
    int id,
    double amount,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE User SET distance = distance + ?2 WHERE id = ?1',
        arguments: [id, amount]);
  }

  @override
  Future<void> updateUserLevel(
    int id,
    int newLevel,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE User SET level = ?2 WHERE id  = ?1',
        arguments: [id, newLevel]);
  }

  @override
  Future<void> updateUserUsername(
    int id,
    String newUsername,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE User SET username  = ?2 WHERE id  = ?1',
        arguments: [id, newUsername]);
  }

  @override
  Future<void> updateUserEmail(
    int id,
    String newEmail,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE User SET email  = ?2 WHERE id  = ?1',
        arguments: [id, newEmail]);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.replace);
  }
}

class _$PlacesDao extends PlacesDao {
  _$PlacesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _placeInsertionAdapter = InsertionAdapter(
            database,
            'Place',
            (Place item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'imageLink': item.imageLink,
                  'userMade': item.userMade ? 1 : 0,
                  'description': item.description
                }),
        _placeUpdateAdapter = UpdateAdapter(
            database,
            'Place',
            ['id'],
            (Place item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'imageLink': item.imageLink,
                  'userMade': item.userMade ? 1 : 0,
                  'description': item.description
                }),
        _placeDeletionAdapter = DeletionAdapter(
            database,
            'Place',
            ['id'],
            (Place item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'imageLink': item.imageLink,
                  'userMade': item.userMade ? 1 : 0,
                  'description': item.description
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Place> _placeInsertionAdapter;

  final UpdateAdapter<Place> _placeUpdateAdapter;

  final DeletionAdapter<Place> _placeDeletionAdapter;

  @override
  Future<List<Place>> findAllPlaces() async {
    return _queryAdapter.queryList('SELECT * FROM Place',
        mapper: (Map<String, Object?> row) => Place(
            row['id'] as int?,
            row['name'] as String?,
            row['latitude'] as double,
            row['longitude'] as double,
            row['imageLink'] as String,
            row['description'] as String,
            (row['userMade'] as int) != 0));
  }

  @override
  Future<Place?> findPlaceByName(String name) async {
    return _queryAdapter.query('SELECT * FROM Place WHERE name= ?1',
        mapper: (Map<String, Object?> row) => Place(
            row['id'] as int?,
            row['name'] as String?,
            row['latitude'] as double,
            row['longitude'] as double,
            row['imageLink'] as String,
            row['description'] as String,
            (row['userMade'] as int) != 0),
        arguments: [name]);
  }

  @override
  Future<List<Place>?> findUsermadePlaces() async {
    return _queryAdapter.queryList('SELECT * FROM Place WHERE userMade = true',
        mapper: (Map<String, Object?> row) => Place(
            row['id'] as int?,
            row['name'] as String?,
            row['latitude'] as double,
            row['longitude'] as double,
            row['imageLink'] as String,
            row['description'] as String,
            (row['userMade'] as int) != 0));
  }

  @override
  Future<List<String>> getAllPlaceNames() async {
    return _queryAdapter.queryList('SELECT name FROM Place',
        mapper: (Map<String, Object?> row) => row.values.first as String);
  }

  @override
  Future<void> insertPlace(Place place) async {
    await _placeInsertionAdapter.insert(place, OnConflictStrategy.replace);
  }

  @override
  Future<void> updatePlace(Place place) async {
    await _placeUpdateAdapter.update(place, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteExposure(Place place) async {
    await _placeDeletionAdapter.delete(place);
  }
}

class _$VisitedPlaceDao extends VisitedPlaceDao {
  _$VisitedPlaceDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _visitedPlaceInsertionAdapter = InsertionAdapter(
            database,
            'VisitedPlace',
            (VisitedPlace item) => <String, Object?>{
                  'id': item.id,
                  'idUser': item.idUser,
                  'idPlace': item.idPlace,
                  'distance': item.distance
                }),
        _visitedPlaceUpdateAdapter = UpdateAdapter(
            database,
            'VisitedPlace',
            ['id'],
            (VisitedPlace item) => <String, Object?>{
                  'id': item.id,
                  'idUser': item.idUser,
                  'idPlace': item.idPlace,
                  'distance': item.distance
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<VisitedPlace> _visitedPlaceInsertionAdapter;

  final UpdateAdapter<VisitedPlace> _visitedPlaceUpdateAdapter;

  @override
  Future<List<VisitedPlace>> findAllVisitedPlaces() async {
    return _queryAdapter.queryList('SELECT * FROM VisitedPlace',
        mapper: (Map<String, Object?> row) => VisitedPlace(
            row['id'] as int?,
            row['idUser'] as int,
            row['idPlace'] as int,
            row['distance'] as double?));
  }

  @override
  Future<void> deleteVisitedPlace(int idUser) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM VisitedPlace WHERE idUser = ?1',
        arguments: [idUser]);
  }

  @override
  Future<List<VisitedPlace>?> findAllPlacesByAUser(int idUser) async {
    return _queryAdapter.queryList(
        'SELECT * FROM VisitedPlace WHERE idUser=?1 ORDER BY id ASC',
        mapper: (Map<String, Object?> row) => VisitedPlace(
            row['id'] as int?,
            row['idUser'] as int,
            row['idPlace'] as int,
            row['distance'] as double?),
        arguments: [idUser]);
  }

  @override
  Future<int?> findVisitedPlacesByUser(int idUser) async {
    return _queryAdapter.query(
        'SELECT DISTINCT COUNT(idPlace) FROM VisitedPlace WHERE idUser = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [idUser]);
  }

  @override
  Future<void> insertVisitedPlace(VisitedPlace visitedPlace) async {
    await _visitedPlaceInsertionAdapter.insert(
        visitedPlace, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUVisitedPlace(VisitedPlace visitedPlace) async {
    await _visitedPlaceUpdateAdapter.update(
        visitedPlace, OnConflictStrategy.replace);
  }
}
