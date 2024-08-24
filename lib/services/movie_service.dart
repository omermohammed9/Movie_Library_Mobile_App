import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String apiUrl = 'http://localhost:1010/movies';

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(Uri.parse('$apiUrl'));
    // print(response.body);

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      var data = json.decode(response.body);
      // print('Parsed response data: $data');

      if (data is Map && data['data'] != null) {
        List<dynamic> movies =
            data['data']; // Extract 'data' key which contains the movie array
        return movies.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        throw Exception('Unexpected response structure');
      }
    } else {
      throw Exception('Failed to load movies');
    }
  }

  // Fetch actors based on movieId and display
  // Fetch actors based on movieId
  Future<List<Actor>> fetchActors(int movieId) async {
    final response = await http.get(Uri.parse('$apiUrl/$movieId/actors'));
    if (response.statusCode == 200) {
      var movieData = json.decode(response.body);
      List<dynamic> actors = movieData['movie']['actors'];
      return actors.map((actor) => Actor.fromJson(actor)).toList();
    } else {
      throw Exception('Failed to load actors');
    }
  }

  Future<void> editMovie(int movieId, Map<String, dynamic> updatedData) async {
    final response = await http.put(
      Uri.parse('http://localhost:1010/movies/$movieId'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update movie');
    }
  }
}
