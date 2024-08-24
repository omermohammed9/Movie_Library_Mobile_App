import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/movie_provider.dart';
import './screens/movie_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MovieProvider()..loadMovies(),
      child: MaterialApp(
        title: 'Movies Library',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        debugShowCheckedModeBanner: false,
        home: const MovieListScreen(),
      ),
    );
  }
}
