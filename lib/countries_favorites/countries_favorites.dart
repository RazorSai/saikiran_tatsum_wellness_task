import 'package:flutter/material.dart';
import 'package:tatsam_wellness_flutter_task/countries/controller/countries.dart';
import 'package:tatsam_wellness_flutter_task/favorites/controller/favorites.dart';

class CountriesFavoritesScreen extends StatefulWidget {
  @override
  _CountriesFavoritesScreenState createState() =>
      _CountriesFavoritesScreenState();
}

class _CountriesFavoritesScreenState extends State<CountriesFavoritesScreen> {
  PageController controller;

  var allScreens = [CountriesScreen(), FavoritesScreen()];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemBuilder: (context, index) {
          return allScreens[index];
        },
        itemCount: allScreens.length,
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Widget bottomNavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: "Countries",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: "Favorites")
      ],
      onTap: (index) {
        controller.animateToPage(index,
            duration: Duration(milliseconds: 100), curve: Curves.ease);
      },
    );
  }
}
