import 'package:flutter/material.dart';
import 'package:progetto_wearable/repositories/databaseRepository.dart';
import 'screens/screens.dart';
import 'package:progetto_wearable/utils/utils.dart';
import 'database/database.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppDatabase database =
      await $FloorAppDatabase.databaseBuilder('app_database.db').build();

  final databaseRepository = DatabaseRepository(database: database);
  runApp(ChangeNotifierProvider<DatabaseRepository>(
    create: ((context) => databaseRepository),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Palette.mainColor,
      ),
      home: LoginPage(),
    );
  }
}
