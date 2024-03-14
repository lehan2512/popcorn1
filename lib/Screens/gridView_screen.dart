// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:popcorn1/Screens/home_screen.dart';
import 'package:popcorn1/Screens/login_screen.dart';
import 'package:popcorn1/Screens/search_screen.dart';
import 'package:popcorn1/colours.dart';
import 'package:popcorn1/constants.dart';
import '../Models/movie.dart';
import 'movieDetails_screen.dart';

class CategoryListScreen extends StatelessWidget {
  final List<Movie> movies;
  final String categoryTitle;

  const CategoryListScreen({super.key, 
    required this.movies,
    required this.categoryTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of items per row
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 15.0,
        ),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailsScreen(
                    movie: movies[index],
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage(
                    '${Constants.imagePath}${movies[index].posterPath}',
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
              height: 300, // Adjust the height as needed
              width: 200,
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colours.scaffoldBgColour,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              color: Colors.white,
              iconSize: 45,
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            IconButton(
              color: Colors.white,
              iconSize: 45,
              icon: const Icon(Icons.search),
              onPressed: () {
                // Navigate to the search screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SearchScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                // Navigate to the watchlist screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
