import 'package:flutter/material.dart';
import 'package:tatsam_wellness_flutter_task/countries_favorites/countries_favorites.dart';
import 'package:tatsam_wellness_flutter_task/service_locator/service_locator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tatsum Task',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CountriesFavoritesScreen(),
    );
  }
}
