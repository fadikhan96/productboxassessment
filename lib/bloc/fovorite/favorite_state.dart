part of 'favorite_cubit.dart';


abstract class FavoriteState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<Map<String, dynamic>> favorites;

  FavoriteLoaded({required this.favorites});

  @override
  List<Object?> get props => [favorites];
}

class FavoriteUpdated extends FavoriteState {
  final List<Map<String, dynamic>> favorites;

  FavoriteUpdated({required this.favorites});

  @override
  List<Object?> get props => [favorites];
}

class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError({required this.message});

  @override
  List<Object?> get props => [message];
}
