import 'package:tatsam_wellness_flutter_task/countries/model/countries_model.dart';
import 'package:tatsam_wellness_flutter_task/database/helper/database_helper.dart';
import 'package:tatsam_wellness_flutter_task/service_locator/service_locator.dart';

/*
* Repository for managing actions related to Favorites.
* */
class FavoritesRepository {
  DatabaseHelper helper = locator<DatabaseHelper>();

  Future<int> addFavorites(CountriesModel countryModel) async {
    return await helper.insertIntoTableFavorites(countryModel.toDatabaseMap());
  }

  Future<int> checkIfFavoritesAdded(String countryCode) async {
    return await helper.checkIfFavoriteExists(countryCode);
  }

  Future<int> removeFavoritesFromDatabase(String countryCode) async {
    return await helper.removeFavoriteFromDatabase(countryCode);
  }

  Future<List<CountriesModel>> getListOfFavoritesCountries() async {
    return await helper.getListOfFavoriteCountries();
  }
}
