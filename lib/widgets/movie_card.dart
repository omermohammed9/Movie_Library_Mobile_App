import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../screens/edit_movie_screen.dart';
import '../screens/movie_detail_screen.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(
              movie: movie,
              editButton: IconButton(
                icon: const Icon(Icons.edit,
                    color: Colors.blue), // Edit button icon
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditMovieScreen(movie: movie),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12), // Rounded corners for the card
        ),
        elevation: 4,
        color: Colors.black, // Adds a subtle shadow
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    BorderRadius.circular(12), // Rounded corners for the image
                child: Image.network(
                  movie.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      color:
                          Colors.grey[900], // Subtle fallback for broken images
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.white, size: 40),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Text(
                movie.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Genre: ${movie.genre}',
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
              const SizedBox(height: 4),
              Text(
                'Release Year: ${movie.releaseYear}',
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.arrow_forward_ios,
                    size: 18, color: Colors.grey[400]),
              ),
            ],
          ),
        ), // Background of the card
      ),
    );
  }
}
