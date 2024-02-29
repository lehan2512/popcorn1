import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popcorn1/Models/movie.dart';

class MovieList extends StatelessWidget {
  final String category;
  final Future<List<Movie>> categoryName;
  final Widget sliderWidget;

  MovieList({
    required this.category,
    required this.categoryName,
    required this.sliderWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          category,
          style: GoogleFonts.aBeeZee(fontSize: 20),
        ),
        const SizedBox(height: 15),
        SizedBox(
          child: FutureBuilder(
            future: categoryName,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              } else if (snapshot.hasData) {
                return sliderWidget;
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}