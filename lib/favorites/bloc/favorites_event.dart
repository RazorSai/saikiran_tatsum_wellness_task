part of 'favorites_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
}

class GetFavoriteCountries extends FavoritesEvent {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
