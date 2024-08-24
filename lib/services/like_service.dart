import 'dart:convert';
import 'package:http/http.dart' as http;

class LikeService {
  Future<int> fetchLikeCount(int movieId) async {
    final response = await http
        .get(Uri.parse('http://localhost:1010/likes/movies/$movieId/likes'));

    // print('API Response: ${response.statusCode}');
    // print('API Body: ${response.body}');

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data['likeCount'] ?? 0;
    } else {
      throw Exception('Failed to load likes');
    }
  }

  Future<void> addLike(int movieId) async {
    final response = await http.post(
      Uri.parse('http://localhost:1010/likes/movies/$movieId/like'),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add like');
    }
  }
}
