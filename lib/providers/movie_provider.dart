import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = true;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  Future<void> loadMovies() async {
    _isLoading = true;
    notifyListeners();
    try {
      _movies = await MovieService().fetchMovies();
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Function to refresh movies
  // Function to refresh movies
  Future<void> refreshMovies() async {
    _isLoading = true;
    notifyListeners();

    try {
      _movies = await MovieService()
          .fetchMovies(); // Re-fetch the movies and update the list
    } catch (e) {
      print(e);
    } finally {
      _isLoading = false;
      notifyListeners(); // Notify listeners to update the UI
    }
  }
}
