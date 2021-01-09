import 'package:flutter/material.dart';
import 'package:tatsam_wellness_flutter_task/countries/model/countries_model.dart';

class FavoritesCell extends StatelessWidget {
  final CountriesModel countriesModel;

  final int index;

  const FavoritesCell(this.countriesModel, this.index);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        "${countriesModel.countryName} - ${countriesModel.countryCode}",
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Text(
          "Region - ${countriesModel.countryRegion}",
          style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
