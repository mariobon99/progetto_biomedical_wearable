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
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `username` TEXT NOT NULL, `password` TEXT NOT NULL, `email` TEXT NOT NULL, `level` INTEGER NOT NULL, `distance` REAL NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Place` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `latitude` TEXT NOT NULL, `longitude` TEXT NOT NULL, `imageLink` TEXT NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `VisitedPlace` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `idUser` INTEGER NOT NULL, `idPlace` INTEGER NOT NULL, FOREIGN KEY (`idUser`) REFERENCES `User` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, FOREIGN KEY (`idPlace`) REFERENCES `Place` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION)');

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
                  'password': item.password,
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
                  'password': item.password,
                  'email': item.email,
                  'level': item.level,
                  'distance': item.distance
                }),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'username': item.username,
                  'password': item.password,
                  'email': item.email,
                  'level': item.level,
                  'distance': item.distance
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> findAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['username'] as String,
            row['password'] as String,
            row['email'] as String,
            row['level'] as int,
            row['distance'] as double));
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
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
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
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'imageLink': item.imageLink
                }),
        _placeUpdateAdapter = UpdateAdapter(
            database,
            'Place',
            ['id'],
            (Place item) => <String, Object?>{
                  'id': item.id,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'imageLink': item.imageLink
                }),
        _placeDeletionAdapter = DeletionAdapter(
            database,
            'Place',
            ['id'],
            (Place item) => <String, Object?>{
                  'id': item.id,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'imageLink': item.imageLink
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Place> _placeInsertionAdapter;

  final UpdateAdapter<Place> _placeUpdateAdapter;

  final DeletionAdapter<Place> _placeDeletionAdapter;

  @override
  Future<List<Place>> findAllPlaces() async {
    return _queryAdapter.queryList('SELECT * FROM Places',
        mapper: (Map<String, Object?> row) => Place(
            row['id'] as int?,
            row['latitude'] as String,
            row['longitude'] as String,
            row['imageLink'] as String));
  }

  @override
  Future<void> insertPlace(Place place) async {
    await _placeInsertionAdapter.insert(place, OnConflictStrategy.abort);
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
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _visitedPlaceInsertionAdapter = InsertionAdapter(
            database,
            'VisitedPlace',
            (VisitedPlace item) => <String, Object?>{
                  'id': item.id,
                  'idUser': item.idUser,
                  'idPlace': item.idPlace
                },
            changeListener),
        _visitedPlaceUpdateAdapter = UpdateAdapter(
            database,
            'VisitedPlace',
            ['id'],
            (VisitedPlace item) => <String, Object?>{
                  'id': item.id,
                  'idUser': item.idUser,
                  'idPlace': item.idPlace
                },
            changeListener),
        _visitedPlaceDeletionAdapter = DeletionAdapter(
            database,
            'VisitedPlace',
            ['id'],
            (VisitedPlace item) => <String, Object?>{
                  'id': item.id,
                  'idUser': item.idUser,
                  'idPlace': item.idPlace
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<VisitedPlace> _visitedPlaceInsertionAdapter;

  final UpdateAdapter<VisitedPlace> _visitedPlaceUpdateAdapter;

  final DeletionAdapter<VisitedPlace> _visitedPlaceDeletionAdapter;

  @override
  Future<List<User>> findAllVisitedPlaces() async {
    return _queryAdapter.queryList('SELECT * FROM VisitedPlace',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int?,
            row['username'] as String,
            row['password'] as String,
            row['email'] as String,
            row['level'] as int,
            row['distance'] as double));
  }

  @override
  Stream<VisitedPlace?> findAllPlacesByAUser(int idUser) {
    return _queryAdapter.queryStream(
        'SELECT idPlace FROM VisitedPlace WHERE idUser=?1',
        mapper: (Map<String, Object?> row) => VisitedPlace(
            row['id'] as int?, row['idUser'] as int, row['idPlace'] as int),
        arguments: [idUser],
        queryableName: 'VisitedPlace',
        isView: false);
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

  @override
  Future<void> deleteVisitedPlace(VisitedPlace visitedPlace) async {
    await _visitedPlaceDeletionAdapter.delete(visitedPlace);
  }
}
