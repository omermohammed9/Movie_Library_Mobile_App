class Movie {
  final int id;
  final String title;
  final String description;
  final int releaseYear;
  final String genre;
  final String imageUrl;
  final int directorId;
  final String directorName;
  final List<Actor> actors;
  final List<Comment> comments;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.releaseYear,
    required this.genre,
    required this.imageUrl,
    required this.directorId,
    required this.directorName,
    required this.actors,
    required this.comments,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    var actorList = json['actors'] != null
        ? (json['actors'] as List).map((i) => Actor.fromJson(i)).toList()
        : <Actor>[]; // Return an empty list if 'actors' is null
    var commentList = json['comments'] != null
        ? (json['comments'] as List).map((i) => Comment.fromJson(i)).toList()
        : <Comment>[]; // Handle null comments gracefully

    return Movie(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      releaseYear: json['release_year'],
      genre: json['genre'],
      imageUrl: json['image_url'],
      directorId: json['director_id'],
      directorName: json['director_name'],
      actors: actorList,
      comments: commentList,
    );
  }
}

class Actor {
  final String name;
  final int age;
  final String countryOfOrigin;

  Actor({required this.name, required this.age, required this.countryOfOrigin});

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      name: json['name'],
      age: json['age'],
      countryOfOrigin: json['country_of_origin'],
    );
  }
}

class Comment {
  final String text;
  final DateTime createdAt;

  Comment({
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      text: json['comment'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at']),
    );
  }
}
