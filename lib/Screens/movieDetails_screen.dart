import 'package:flutter/material.dart';
import 'package:popcorn1/Models/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  const MovieDetailsScreen({super.key, required this.movie});

final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      appBar: AppBar(),
      body: Center
      (
        child: Text(movie.title)
      )
    );
  }
}