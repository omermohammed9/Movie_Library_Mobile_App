import 'package:flutter/material.dart';
import 'package:movie_library_app/services/like_service.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../services/comment_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;
  final Widget editButton;

  const MovieDetailScreen({
    required this.movie,
    required this.editButton,
    super.key,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late MovieService movieService;
  late TextEditingController _commentController; // Add comment controller
  late LikeService likeService;
  int likeCount = 0;
  List<Actor> actors = [];
  List<Comment> comments = [];

  @override
  void didUpdateWidget(covariant MovieDetailScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    fetchMovieDetails(); // Refetch details when coming back
  }

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController(); // Initialize controller
    movieService = MovieService();
    likeService = LikeService();
    fetchMovieDetails();
  }

  @override
  void dispose() {
    _commentController.dispose(); // Dispose controller to avoid memory leaks
    super.dispose();
  }

  void fetchMovieDetails() async {
    try {
      var fetchedActors = await movieService.fetchActors(widget.movie.id);
      var commentService = CommentService();
      var fetchedComments = await commentService.fetchComments(widget.movie.id);
      var likeService = LikeService();
      var fetchedLikes = await likeService.fetchLikeCount(widget.movie.id);

      setState(() {
        actors = fetchedActors;
        comments = fetchedComments;
        likeCount = fetchedLikes;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _navigateBack() {
    Navigator.pop(context,
        true); // Return 'true' to signal that movie details were updated
  }

  Future<void> handleLikeButton() async {
    try {
      await likeService.addLike(widget.movie.id); // Call to add like
      setState(() {
        likeCount += 1; // Increment the like count
      });
    } catch (e) {
      print('Error adding like: $e');
    }
  }

  // Function to handle adding comment
  void _addComment() async {
    if (_commentController.text.isNotEmpty) {
      try {
        var commentService = CommentService();
        await commentService.addComment(
            widget.movie.id, _commentController.text);
        fetchMovieDetails(); // Reload comments after adding
        _commentController.clear(); // Clear the input field
      } catch (e) {
        print('Error adding comment: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.movie.title,
          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[widget.editButton],
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _navigateBack,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.black12,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    widget.movie.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error,
                          size: 50, color: Colors.white);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                widget.movie.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.movie.description,
                style: TextStyle(fontSize: 16, color: Colors.grey[400]),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.grey[400]),
                  const SizedBox(width: 5),
                  Text(
                    'Release Year: ${widget.movie.releaseYear}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.category, color: Colors.grey[400]),
                  const SizedBox(width: 5),
                  Text(
                    'Genre: ${widget.movie.genre}',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Divider(color: Colors.grey[600]),
              const SizedBox(height: 10),
              Text(
                'Director: ${widget.movie.directorName}',
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text('Actors:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              const SizedBox(height: 5),
              actors.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: actors
                          .map((actor) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  '${actor.name} (Age: ${actor.age}, Country: ${actor.countryOfOrigin})',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[400]),
                                ),
                              ))
                          .toList(),
                    )
                  : Text('No actors available',
                      style: TextStyle(color: Colors.grey[400])),
              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      handleLikeButton();
                    },
                    child: Row(
                      children: [
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                scale: animation, child: child);
                          },
                          child: Icon(
                            Icons.thumb_up,
                            color:
                                likeCount > 0 ? Colors.blue : Colors.grey[400],
                            key: ValueKey<int>(
                                likeCount), // Unique key for animation
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          'Likes: $likeCount',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text('Comments:',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              comments.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: comments
                          .map((comment) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Text(
                                  '${comment.text} at ${comment.createdAt.toLocal()}',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey[400]),
                                ),
                              ))
                          .toList(),
                    )
                  : Text('No comments available',
                      style: TextStyle(color: Colors.grey[400])),
              // TextField for adding comments
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TextField(
                  controller: _commentController, // Attach controller
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),

// Button to submit comment
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: _addComment, // Call add comment function
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 33, 243, 47), // Button color
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('Add Comment',
                      style: TextStyle(color: Colors.white)),
                ),
              ),

// Button to navigate back
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: ElevatedButton(
                  onPressed: _navigateBack, // Call navigate back function
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Back to Movies',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
