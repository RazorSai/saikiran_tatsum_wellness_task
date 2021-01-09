import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tatsam_wellness_flutter_task/countries/model/countries_model.dart';
import 'package:tatsam_wellness_flutter_task/global/repository/favorites_repository.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  FavoritesBloc() : super(FavoritesLoading());

  FavoritesRepository favoritesRepository = FavoritesRepository();

  @override
  Stream<FavoritesState> mapEventToState(
    FavoritesEvent event,
  ) async* {
    if (event is GetFavoriteCountries) {
      yield* getFavoriteCountries();
    }
  }

  /*Here we get the list of favorite countries added by user.
  * All the entries are saved in the local database of the app.*/
  Stream<FavoritesState> getFavoriteCountries() async* {
    yield FavoritesLoading();
    try {
      List<CountriesModel> countriesList =
          await favoritesRepository.getListOfFavoritesCountries();
      yield FavoritesLoaded(countriesList);
    } catch (e) {
      yield FavoritesError();
    }
  }
}
