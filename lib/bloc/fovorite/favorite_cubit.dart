import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/movies.dart';
import '../../services/firebase_services.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(FavoriteInitial());

  List<String> favoriteMovieIds = [];

  Future<void> toggleFavorite(Movie movie) async {
    try {
      emit(FavoriteLoading());
      final movieData = {
        'id': movie.id,
        'title': movie.title,
        'overview': movie.overview,
        'poster_path': movie.posterPath,
      };

      await FirebaseService.toggleFavoriteMovie(movieData);
      final favorites = await FirebaseService.getFavoriteMovies();
      emit(FavoriteLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoriteError(message: 'Failed to update favorites: $e'));
    }
  }


  Future<void> loadFavorites() async {
    try {
      emit(FavoriteLoading());
      final favorites = await FirebaseService.getFavoriteMovies();
      emit(FavoriteLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoriteError(message: 'Failed to load favorites: $e'));
    }
  }
}
