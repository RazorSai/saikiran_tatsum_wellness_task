import 'package:flutter/material.dart';
import 'package:tatsam_wellness_flutter_task/countries/model/countries_model.dart';

class CountriesCell extends StatelessWidget {
  final CountriesModel countriesModel;

  final int index;

  final MarkUnMarkFavorite markUnMarkFavorite;

  const CountriesCell(this.countriesModel, this.index,
      {this.markUnMarkFavorite});

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
      trailing: IconButton(
        icon: Icon(
          countriesModel.isFavorite ? Icons.star : Icons.star_border,
        ),
        color: countriesModel.isFavorite
            ? Colors.yellow.shade700
            : Colors.grey.shade700,
        onPressed: () {
          if (markUnMarkFavorite != null) {
            markUnMarkFavorite(index, countriesModel);
          }
        },
      ),
    );
  }
}

typedef MarkUnMarkFavorite = void Function(
    int index, CountriesModel countriesModel);
