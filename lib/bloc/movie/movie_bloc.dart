
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:productboxassessment/models/movies.dart';
import '../../repository/movie_repository.dart';

part 'movie_events.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository repository;

  MovieBloc(this.repository) : super(MovieLoading()) {
    on<FetchMovies>((event, emit) async {
      try {
        List<Movie> currentMovies = [];
        if (state is MovieLoaded) {
          currentMovies = (state as MovieLoaded).movies;
        }

        final newMovies = await repository.fetchMovies(event.page);
        emit(MovieLoaded(movies: [...currentMovies, ...newMovies]));
      } catch (e) {
        emit(MovieError('Failed to fetch movies: ${e.toString()}'));
      }
    });

  }
}
