
part of 'movie_bloc.dart';


abstract class MovieEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchMovies extends MovieEvent {
  final int page;

  FetchMovies({this.page = 1});

  @override
  List<Object> get props => [page];
}
