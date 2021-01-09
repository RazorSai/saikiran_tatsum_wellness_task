part of 'countries_bloc.dart';

abstract class CountriesEvent extends Equatable {
  const CountriesEvent();
}

class LoadCountries extends CountriesEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddCountryToFavorite extends CountriesEvent {
  final CountriesModel countriesModel;
  final int selectedIndex;

  const AddCountryToFavorite(this.countriesModel, this.selectedIndex);

  @override
  // TODO: implement props
  List<Object> get props => [this.countriesModel, this.selectedIndex];
}

class RemoveCountryToFavorite extends CountriesEvent {
  final CountriesModel countriesModel;
  final int selectedIndex;

  const RemoveCountryToFavorite(this.countriesModel, this.selectedIndex);

  @override
  // TODO: implement props
  List<Object> get props => [this.countriesModel, this.selectedIndex];
}

class LoadCountriesPagination extends CountriesEvent {
  final int setIndex;

  const LoadCountriesPagination(this.setIndex);

  @override
  // TODO: implement props
  List<Object> get props => [this.setIndex];
}
