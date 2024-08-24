import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../services/movie_service.dart';

class EditMovieScreen extends StatefulWidget {
  final Movie movie;
  const EditMovieScreen({super.key, required this.movie});

  @override
  _EditMovieScreenState createState() => _EditMovieScreenState();
}

class _EditMovieScreenState extends State<EditMovieScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  String selectedGenre = 'Action'; // Set initial value for the genre
  int selectedYear = DateTime.now().year; // Set the current year as default
  String imageUrl = '';
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.movie.title);
    _descriptionController =
        TextEditingController(text: widget.movie.description);
    selectedGenre =
        widget.movie.genre; // Assuming you have genre in Movie object
    selectedYear = widget
        .movie.releaseYear; // Assuming you have releaseYear in Movie object
    imageUrl = widget.movie.imageUrl;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Movie')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),

            // Dropdown for Year
            DropdownButton<int>(
              value: selectedYear,
              items: List.generate(100, (index) {
                int year = DateTime.now().year - index;
                return DropdownMenuItem(
                  value: year,
                  child: Text(year.toString()),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedYear = newValue!;
                });
              },
            ),

            // Dropdown for Genre
            DropdownButton<String>(
              value: selectedGenre,
              items:
                  ['Action', 'Comedy', 'Drama', 'Adventure', 'Sci-Fi', 'Horror']
                      .map((genre) => DropdownMenuItem(
                            value: genre,
                            child: Text(genre),
                          ))
                      .toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedGenre = newValue!;
                });
              },
            ),

            // Save Changes Button
            ElevatedButton(
              onPressed: () async {
                var updatedMovie = {
                  'title': _titleController.text,
                  'description': _descriptionController.text,
                  'release_year': selectedYear,
                  'genre': selectedGenre,
                  'image_url':
                      imageUrl.isEmpty ? 'default_image_url.jpg' : imageUrl,
                };
                await MovieService().editMovie(widget.movie.id, updatedMovie);
                Navigator.pop(
                    context, true); // Pass true to signal a successful update
              },
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
