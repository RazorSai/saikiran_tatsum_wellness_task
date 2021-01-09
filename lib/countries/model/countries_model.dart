import 'package:tatsam_wellness_flutter_task/database/helper/database_helper.dart';

class CountriesModel {
  String countryCode;
  String countryName;
  String countryRegion;
  bool isFavorite = false;

  CountriesModel();

  factory CountriesModel.fromJson(
      String countryCode, Map<String, dynamic> countryDetails) {
    CountriesModel countriesModel = CountriesModel();

    countriesModel.countryCode = countryCode;
    countriesModel.countryName = countryDetails["country"];
    countriesModel.countryRegion = countryDetails["region"];

    return countriesModel;
  }

  Map<String, dynamic> toDatabaseMap() {
    Map<String, dynamic> map = Map();
    map[DatabaseHelper.COLUMN_COUNTRY_CODE] = countryCode;
    map[DatabaseHelper.COLUMN_COUNTRY_NAME] = countryName;
    map[DatabaseHelper.COLUMN_COUNTRY_REGION] = countryRegion;
    return map;
  }

  factory CountriesModel.fromDatabase(Map<String, dynamic> countryDetails) {
    CountriesModel countriesModel = CountriesModel();

    countriesModel.countryCode =
        countryDetails[DatabaseHelper.COLUMN_COUNTRY_CODE];
    countriesModel.countryName =
        countryDetails[DatabaseHelper.COLUMN_COUNTRY_NAME];
    countriesModel.countryRegion =
        countryDetails[DatabaseHelper.COLUMN_COUNTRY_REGION];

    return countriesModel;
  }
}
