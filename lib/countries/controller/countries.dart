import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tatsam_wellness_flutter_task/countries/bloc/countries_bloc.dart';
import 'package:tatsam_wellness_flutter_task/countries/model/countries_model.dart';
import 'package:tatsam_wellness_flutter_task/countries/view/countries_cell.dart';

class CountriesScreen extends StatefulWidget {
  @override
  _CountriesScreenState createState() => _CountriesScreenState();
}

class _CountriesScreenState extends State<CountriesScreen>
    with AutomaticKeepAliveClientMixin {
  CountriesBloc _countriesBloc;

  List<CountriesModel> countries = List();

  bool showPaginationLoader = false;

  ScrollController countriesListScrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _countriesBloc = CountriesBloc();
    countriesListScrollController.addListener(() {
      if (countriesListScrollController.position.pixels ==
          countriesListScrollController.position.maxScrollExtent) {
        if (countries.length > 0) {
          paginateCountries(countries.length);
        }
      }
    });
    loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Countries"),
      ),
      body: BlocProvider(
        create: (_) => _countriesBloc,
        child: BlocListener<CountriesBloc, CountriesState>(
          listener: (_, state) {
            if (state is CountryAddingToFavorites) {
              print("Country adding to favorites");
            } else if (state is CountryAddedToFavorites) {
              countries[state.selectedIndex].isFavorite =
                  !state.countrySelected.isFavorite;
            } else if (state is CountryFailedToAddInFavorites) {
              print("Country failed to add in favorites");
            }
          },
          child: BlocBuilder<CountriesBloc, CountriesState>(
            builder: (builderContext, state) {
              if (state is CountriesLoading) {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (state is CountriesError) {
                return Container(
                  child: Center(
                    child: Text(state.statusMessage),
                  ),
                );
              } else if (state is NoInternetAvailable) {
                return Container(
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Please check your network connectivity.",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 10.0),
                              child: RaisedButton(
                                child: Text(
                                  "Retry",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16.0),
                                ),
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  loadCountries();
                                },
                              ),
                            ),
                          )
                        ]),
                  ),
                );
              } else if (state is CountriesLoaded) {
                countries = state.countriesList;
              } else if (state is CountriesPaginationLoaded) {
                if (state.countriesList != null) {
                  if (state.countriesList.length > 0) {
                    countries.addAll(state.countriesList);
                  }
                }
              }

              if (countries.length > 0) {
                return Container(
                    color: Colors.white,
                    child: RefreshIndicator(
                      onRefresh: loadCountries,
                      child: ListView.separated(
                        controller: countriesListScrollController,
                        itemBuilder: (listContext, index) {
                          CountriesModel countriesModel = countries[index];
                          return Padding(
                            padding:
                                EdgeInsets.only(top: index == 0 ? 10.0 : 0.0),
                            child: CountriesCell(
                              countriesModel,
                              index,
                              markUnMarkFavorite:
                                  (selectedIndex, countrySelected) {
                                setState(() {
                                  if (countrySelected.isFavorite) {
                                    removeFavorites(
                                        countriesModel, selectedIndex);
                                  } else {
                                    addToFavorites(
                                        countrySelected, selectedIndex);
                                  }
                                });
                              },
                            ),
                          );
                        },
                        separatorBuilder: (separatorContext, index) {
                          return Divider();
                        },
                        itemCount: countries.length,
                      ),
                    ));
              } else {
                return Container(
                  child: Center(
                    child: Text("No Countries Available"),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  paginateCountries(int setIndex) {
    _countriesBloc.add(LoadCountriesPagination(setIndex));
  }

  Future loadCountries() async {
    _countriesBloc.add(LoadCountries());
  }

  void addToFavorites(CountriesModel countriesModel, int selectedIndex) async {
    _countriesBloc.add(AddCountryToFavorite(countriesModel, selectedIndex));
  }

  void removeFavorites(CountriesModel countriesModel, int selectedIndex) async {
    _countriesBloc.add(RemoveCountryToFavorite(countriesModel, selectedIndex));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _countriesBloc.close();
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
