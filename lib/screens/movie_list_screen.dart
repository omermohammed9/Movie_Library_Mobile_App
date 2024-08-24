import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import 'edit_movie_screen.dart';
import 'movie_detail_screen.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movies Library')),
      backgroundColor: Colors.black12,
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (movieProvider.movies.isEmpty) {
            return const Center(child: Text('No movies available.'));
          } else {
            return ListView.builder(
              itemCount: movieProvider.movies.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(
                          movie: movieProvider.movies[index],
                          editButton: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final editResult = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditMovieScreen(
                                    movie: movieProvider.movies[index],
                                  ),
                                ),
                              );
                              if (editResult == true) {
                                movieProvider
                                    .refreshMovies(); // Trigger refresh if movie was edited
                              }
                            },
                          ),
                        ),
                      ),
                    );
                    if (result == true) {
                      movieProvider
                          .refreshMovies(); // Trigger refresh when returning
                    }
                  },
                  child: MovieCard(movie: movieProvider.movies[index]),
                );
              },
            );
          }
        },
      ),
    );
  }
}
