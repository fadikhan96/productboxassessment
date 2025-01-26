
part of 'search_cubit.dart';

abstract class SearchState {
  const SearchState();

  bool get isSearching => this is SearchLoaded;
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Movie> filteredMovies;

  const SearchLoaded({required this.filteredMovies});
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});
}
