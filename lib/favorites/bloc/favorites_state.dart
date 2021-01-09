part of 'favorites_bloc.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {
  @override
  List<Object> get props => [];
}

class FavoritesLoading extends FavoritesState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FavoritesLoaded extends FavoritesState {
  final List<CountriesModel> favoritesList;

  const FavoritesLoaded(this.favoritesList);

  @override
  // TODO: implement props
  List<Object> get props => [this.favoritesList];
}

class FavoritesError extends FavoritesState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
