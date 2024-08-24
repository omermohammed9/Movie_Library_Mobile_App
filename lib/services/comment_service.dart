import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_library_app/models/movie.dart';

class CommentService {
  Future<List<Comment>> fetchComments(int movieId) async {
    final response = await http.get(
        Uri.parse('http://localhost:1010/comments/movies/$movieId/comments'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // print('Response data: $data');

      // Since data is an array, no need for data['comment']
      var commentsData = data ?? [];
      // print('Comments data: $commentsData');

      // Loop through each comment object
      // commentsData.forEach((comment) {
      //   // print('Comment: ${comment['comment']}');
      //   // print('Created At: ${comment['created_at']}');
      // });

      // Return the list of comments after mapping them from JSON
      return commentsData
          .map<Comment>((comment) => Comment.fromJson(comment))
          .toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> addComment(int movieId, String commentText) async {
    final response = await http.post(
      Uri.parse('http://localhost:1010/comments/movies/$movieId/comments'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'comment': commentText,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add comment');
    }
  }
}
