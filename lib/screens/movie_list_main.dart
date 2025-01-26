import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:productboxassessment/bloc/movie/movie_bloc.dart';
import 'package:productboxassessment/widgets/movie_card.dart';
import 'package:productboxassessment/widgets/search_bar.dart';
import '../bloc/fovorite/favorite_cubit.dart';
import '../bloc/search/search_cubit.dart';
import '../bloc/theme/theme_cubit.dart';
import '../models/movies.dart';


class MovieListMainScreen extends StatefulWidget {
  const MovieListMainScreen({Key? key}) : super(key: key);

  @override
  State<MovieListMainScreen> createState() => _MovieListMainScreenState();
}

class _MovieListMainScreenState extends State<MovieListMainScreen> {

  int currentPage = 1;

  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<MovieBloc>().add(FetchMovies());
    context.read<FavoriteCubit>().loadFavorites();

    _searchController.addListener(() {
      final query = _searchController.text.trim();
      if (query.isEmpty) {
        context.read<SearchCubit>().clearSearch();
      } else {
        final allMovies = (context.read<MovieBloc>().state as MovieLoaded).movies;
        context.read<SearchCubit>().searchMovies(query, allMovies);
      }
    });
  }

  void _loadNextPage() {
    final state = context.read<MovieBloc>().state;
    if (state is MovieLoaded && !context.read<SearchCubit>().state.isSearching) {
      currentPage = currentPage +1;
      context.read<MovieBloc>().add(FetchMovies(page:currentPage));

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie List'),
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () {
              final themeCubit = context.read<ThemeCubit>();
              themeCubit.toggleTheme();
            },
          ),
        ],
      ),
      body: BlocBuilder<MovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieLoaded) {
            final movies = state.movies;
            final filteredMovies = searchQuery.isEmpty
                ? movies
                : movies.where((movie) => movie.title.toLowerCase().contains(searchQuery)).toList();

            return Column(
              children: [

                SearchField(controller: _searchController),
                Expanded(
                  child: BlocBuilder<SearchCubit, SearchState>(
                    builder: (context, searchState) {
                      if (searchState is SearchLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (searchState is SearchLoaded && searchState.filteredMovies.isNotEmpty) {
                        return _buildMovieGrid(searchState.filteredMovies);
                      } else if (searchState is SearchInitial) {
                        return BlocBuilder<MovieBloc, MovieState>(
                          builder: (context, movieState) {
                            if (movieState is MovieLoaded) {
                              return _buildMovieGrid(movieState.movies);
                            } else if (movieState is MovieLoading) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (movieState is MovieError) {
                              return Center(
                                child: Text(
                                  'Error: ${movieState.message}',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              );
                            } else {
                              return const Center(child: Text('Something went wrong.'));
                            }
                          },
                        );
                      } else {
                        return const Center(child: Text('No results found.'));
                      }
                    },
                  ),
                ),
              ],
            );
          }
          else if (state is MovieError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
      ),
    );
  }


  Widget _buildMovieGrid(List<Movie> movies) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        if (scrollNotification is ScrollEndNotification &&
            scrollNotification.metrics.extentAfter == 0) {
          _loadNextPage();
        }
        return false;
      },
      child: GridView.builder(
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.65,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return MovieCard(movie: movies[index]);
        },
      ),
    );
  }
}
