import 'package:bloc/bloc.dart';
import '../../models/movies.dart';
part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit() : super(SearchInitial());

  void searchMovies(String query, List<Movie> allMovies) {
    try {
      emit(SearchLoading());
      final filteredMovies = query.isEmpty
          ? allMovies
          : allMovies
          .where((movie) => movie.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(SearchLoaded(filteredMovies: filteredMovies));
    } catch (e) {
      emit(SearchError(message: 'Failed to filter movies: $e'));
    }
  }

  void clearSearch() {
    emit(SearchInitial());
  }
}
