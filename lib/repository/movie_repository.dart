import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movies.dart';

class MovieRepository {
  final String apiKey = '4ac9dc1b598fbc8dd8fe1627d10e1028';

  final String baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchMovies(int page) async {
    final response = await http.get(Uri.parse('$baseUrl/discover/movie?api_key=$apiKey&page=$page'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List).map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to fetch movies');
    }
  }
}
