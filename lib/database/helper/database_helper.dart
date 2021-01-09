import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tatsam_wellness_flutter_task/countries/model/countries_model.dart';

class DatabaseHelper {
  Database db;

  static final int _version = 1;

  //TABLE_NAME

  static final String TABLE_FAVORITES = "tbl_favorites";

  static final String COLUMN_COUNTRY_CODE = "clm_country_code";
  static final String COLUMN_COUNTRY_NAME = "clm_country_name";
  static final String COLUMN_COUNTRY_REGION = "clm_country_region";

  DatabaseHelper() {
    initDatabase();
  }

  /*
  * We initialize the Database instance here.
  * The path is set to the data folder which is non accessible to normal user through file browser.
  *
  * */
  void initDatabase() async {
    var dbPath = await getTemporaryDirectory();
    var databasePath = join(dbPath.path, "tatsam.db");
    db = await openDatabase(databasePath,
        onCreate: createDatabase,
        onUpgrade: upgradeDatabase,
        version: _version);
  }

  /*Here we execute database query to create table Favorites.*/
  Future<void> createDatabase(Database db, int version) async {
    db.execute(
        '''CREATE TABLE $TABLE_FAVORITES($COLUMN_COUNTRY_CODE TEXT PRIMARY KEY, $COLUMN_COUNTRY_NAME TEXT, $COLUMN_COUNTRY_REGION TEXT)''');
  }

  Future<void> upgradeDatabase(
      Database db, int oldVersion, int newVersion) async {}

  Future<int> insertIntoTableFavorites(Map<String, dynamic> json) async {
    return await db.insert(TABLE_FAVORITES, json);
  }

  Future<int> checkIfFavoriteExists(String countryCode) async {
    var favoriteExists = await db.query(TABLE_FAVORITES,
        where: '$COLUMN_COUNTRY_CODE = ?', whereArgs: [countryCode]);
    return favoriteExists.length;
  }

  Future<int> removeFavoriteFromDatabase(String countryCode) async {
    return await db.delete(TABLE_FAVORITES,
        where: '$COLUMN_COUNTRY_CODE = ?', whereArgs: [countryCode]);
  }

  Future<List<CountriesModel>> getListOfFavoriteCountries() async {
    var listOfCountries = await db.query(TABLE_FAVORITES);
    List<CountriesModel> countriesList = listOfCountries
        .map((countryDetails) => CountriesModel.fromDatabase(countryDetails))
        .toList();
    return countriesList;
  }
}
