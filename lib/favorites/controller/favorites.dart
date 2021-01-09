import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatsam_wellness_flutter_task/countries/model/countries_model.dart';
import 'package:tatsam_wellness_flutter_task/favorites/bloc/favorites_bloc.dart';
import 'package:tatsam_wellness_flutter_task/favorites/view/favorites_cell.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FavoritesBloc _countriesBloc;

  List<CountriesModel> countries = List();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _countriesBloc = FavoritesBloc();
    loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
      ),
      body: BlocProvider(
        create: (_) => _countriesBloc,
        child: BlocListener<FavoritesBloc, FavoritesState>(
          listener: (_, state) {},
          child: BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (builderContext, state) {
              if (state is FavoritesLoading) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is FavoritesError) {
                return Container(
                  child: Center(
                    child: Text("Failed To Get Favorite Countries List."),
                  ),
                );
              } else if (state is FavoritesLoaded) {
                countries = state.favoritesList;
              }

              if (countries.length > 0) {
                return RefreshIndicator(
                  onRefresh: loadCountries,
                  child: ListView.separated(
                    itemBuilder: (listContext, index) {
                      CountriesModel countriesModel = countries[index];
                      return Padding(
                        padding: EdgeInsets.only(top: index == 0 ? 10.0 : 0.0),
                        child: FavoritesCell(
                          countriesModel,
                          index,
                        ),
                      );
                    },
                    separatorBuilder: (separatorContext, index) {
                      return Divider();
                    },
                    itemCount: countries.length,
                  ),
                );
              } else {
                return Container(
                  child: Center(
                    child: Text("No Countries Added to Favorites"),
                  ),
                );
              }
              ;
            },
          ),
        ),
      ),
    );
  }

  Future loadCountries() async {
    _countriesBloc.add(GetFavoriteCountries());
  }
}
