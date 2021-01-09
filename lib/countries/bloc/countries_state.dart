part of 'countries_bloc.dart';

abstract class CountriesState extends Equatable {
  const CountriesState();
}

class CountriesInitial extends CountriesState {
  @override
  List<Object> get props => [];
}

class CountriesLoading extends CountriesState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CountriesLoaded extends CountriesState {
  final List<CountriesModel> countriesList;

  const CountriesLoaded(this.countriesList);

  @override
  // TODO: implement props
  List<Object> get props => [countriesList];
}

class CountriesPaginationLoaded extends CountriesState {
  final List<CountriesModel> countriesList;

  const CountriesPaginationLoaded(this.countriesList);

  @override
  // TODO: implement props
  List<Object> get props => [countriesList];
}

class CountriesError extends CountriesState {
  final int statusCode;
  final String statusMessage;

  const CountriesError(this.statusCode, this.statusMessage);

  @override
  // TODO: implement props
  List<Object> get props => [statusCode, statusMessage];
}

class CountryAddingToFavorites extends CountriesState {
  @override
  List<Object> get props => [];
}

class CountryAddedToFavorites extends CountriesState {
  final CountriesModel countrySelected;
  final int selectedIndex;

  const CountryAddedToFavorites(this.selectedIndex, this.countrySelected);

  @override
  List<Object> get props => [this.selectedIndex, this.countrySelected];
}

class CountryFailedToAddInFavorites extends CountriesState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class NoInternetAvailable extends CountriesState {
  @override
  List<Object> get props => [];
}
