import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tatsam_wellness_flutter_task/countries/model/countries_model.dart';
import 'package:tatsam_wellness_flutter_task/global/repository/favorites_repository.dart';
import 'package:connectivity/connectivity.dart';

part 'countries_event.dart';

part 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  FavoritesRepository _favoritesRepository = FavoritesRepository();

  List<CountriesModel> allCountriesList = List();

  int paginationLimit = 20;

  CountriesBloc() : super(CountriesLoading());

  @override
  Stream<CountriesState> mapEventToState(
    CountriesEvent event,
  ) async* {
    if (event is LoadCountries) {
      yield* loadCountries();
    } else if (event is LoadCountriesPagination) {
      yield* loadCountriesSet(event.setIndex);
    } else if (event is AddCountryToFavorite) {
      yield* saveCountryInDatabase(event.selectedIndex, event.countriesModel);
    } else if (event is RemoveCountryToFavorite) {
      yield* removeCountryInDatabase(event.selectedIndex, event.countriesModel);
    }
    // TODO: implement mapEventToState
  }

  Stream<CountriesState> loadCountriesSet(int setIndex) async* {
    try {
      /*
      * Here we check if the pagination index is greater than the list of countries.
      * If the pagination index is greater than list of countries,
      * then we simply return empty list indicating that the data has been completely loaded successfully.
      * */
      if (setIndex >= allCountriesList.length) {
        yield CountriesPaginationLoaded(List());
      } else {
        /*
        * Here we increment our range limit by adding the pagination index with the pagination limit(set to 20).
        * */
        int endLimit = setIndex + paginationLimit;
        /*
        *If the endLimit exceeds the length of list of all countries count,
        * then we set the end limit to list of all countries count.
        * */
        if (endLimit >= allCountriesList.length) {
          endLimit = allCountriesList.length;
        }
        var list = allCountriesList.getRange(setIndex, endLimit).toList();
        yield (CountriesPaginationLoaded(list));
      }
    } catch (e) {
      yield CountriesPaginationLoaded(null);
    }
  }

  /*Get list of all countries from api*/
  Stream<CountriesState> loadCountries() async* {
    yield CountriesLoading();
    try {
      /*Check if internet connection is available or not.*/
      bool internetConnected = await checkInternetConnectivity();
      if (internetConnected) {
        http.Response response =
            await http.get("https://api.first.org/data/v1/countries");
        if (response != null) {
          int statusCode = response.statusCode;
          if (statusCode < 200 || statusCode >= 400) {
            yield CountriesError(
                400, "Failed to load countries. Please try again later.");
          } else {
            var responseBody = json.decode(response.body);
            int responseStatusCode = responseBody["status-code"] ?? 0;
            if (responseStatusCode == 200) {
              var data = responseBody["data"];
              List<CountriesModel> countries = List();
              data.forEach((countryCode, countryDetails) {
                /*
                * Here we create a global list for countries and save it in the allCountriesList object
                * to be accessed later for pagination
                * */
                allCountriesList
                    .add(CountriesModel.fromJson(countryCode, countryDetails));
              });

              /*
              * Here we get sub list from the list of all countries.
              *  Currently we get set of 20 countries.
              * */
              countries = allCountriesList.sublist(0, paginationLimit);
              print(responseBody);

              /*
              * Here we get list of favorite countries added by the user*/
              List<CountriesModel> favoriteCountries =
                  await _favoritesRepository.getListOfFavoritesCountries();

              /*
              * Here we iterate through each of the favorite country
              * and set isFavorite boolean to true
              * */
              if (favoriteCountries.length > 0) {
                for (var favoriteCountry in favoriteCountries) {
                  CountriesModel countryExists = countries.singleWhere(
                      (element) =>
                          element.countryCode == favoriteCountry.countryCode,
                      orElse: () => null);
                  if (countryExists != null) {
                    countryExists.isFavorite = true;
                  }
                }
              }

              yield CountriesLoaded(countries);
            } else {
              yield CountriesError(responseStatusCode,
                  "Failed to load countries. Please try again later.");
            }
          }
        } else {
          yield CountriesError(
              400, "Failed to load countries. Please try again later.");
        }
      } else {
        yield NoInternetAvailable();
      }
    } catch (e) {
      yield CountriesError(
          400, "Failed to load countries. Please try again later.");
    }
  }

  /*Here, we check if the internet is available or not.*/
  Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {
      return true;
    }
    return false;
  }

  Stream<CountriesState> saveCountryInDatabase(
      int selectedIndex, CountriesModel countriesModel) async* {
    yield CountryAddingToFavorites();
    try {
      /*
      * Here, we insert the favorite country, selected by the user, in the database.*/
      int insertValue = await _favoritesRepository.addFavorites(countriesModel);
      /*
      * We check if the country is added successfully in database.
      * */
      if (insertValue > 0) {
        yield CountryAddedToFavorites(selectedIndex, countriesModel);
      } else {
        yield CountryFailedToAddInFavorites();
      }
    } catch (e) {
      yield CountryFailedToAddInFavorites();
    }
  }

  Stream<CountriesState> removeCountryInDatabase(
      int selectedIndex, CountriesModel countriesModel) async* {
    yield CountryAddingToFavorites();
    try {
      /*Here we remove the favorite country, selected by the user, from the database.*/
      int insertValue = await _favoritesRepository
          .removeFavoritesFromDatabase(countriesModel.countryCode);
      if (insertValue > 0) {
        yield CountryAddedToFavorites(selectedIndex, countriesModel);
      } else {
        yield CountryFailedToAddInFavorites();
      }
    } catch (e) {
      yield CountryFailedToAddInFavorites();
    }
  }
}
