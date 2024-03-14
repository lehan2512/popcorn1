// ignore_for_file: file_names, camel_case_types

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:popcorn1/Models/movie.dart';
import 'package:popcorn1/Screens/movieDetails_screen.dart';
import 'package:popcorn1/constants.dart';
import 'dart:convert';

class searchBarFunc extends StatefulWidget {
  const searchBarFunc({super.key});

  @override
  State<searchBarFunc> createState() => _searchBarFunState();
}

class _searchBarFunState extends State<searchBarFunc> {
  List<Movie> searchResult = [];

  TextEditingController searchtext = TextEditingController();
  bool showlist = false;
  var val1;
  String selectedFilter = 'Title';

  String get apiKey => Constants.apiKey;

  Future<void> searchlistfunction(String val) async {
    if (val.isEmpty) {
      // If search text is empty, don't make the API call
      return;
    }

    if (selectedFilter == 'Title') {
      await searchMoviesByTitle(val);
    } else if (selectedFilter == 'Actor') {
      await searchMoviesByCast(val);
    }
  }

  Future<void> searchMoviesByTitle(String val) async {
    try {
      var searchMovieUrl =
          'https://api.themoviedb.org/3/search/multi?api_key=${Constants.apiKey}&query=$val&include_adult=false';
      var searchMovieResponse = await http.get(Uri.parse(searchMovieUrl));

      if (searchMovieResponse.statusCode == 200) {
        var tempData = jsonDecode(searchMovieResponse.body);
        var searchJson = tempData['results'];

        List<Movie> tempResult = [];
        for (var i = 0; i < searchJson.length; i++) {
          if (searchJson[i]['media_type'] == 'movie') {
            if (searchJson[i]['id'] != null &&
                searchJson[i]['title'] != null &&
                searchJson[i]['poster_path'] != null &&
                searchJson[i]['vote_average'] != null &&
                searchJson[i]['media_type'] != null) {
              tempResult
                  .add(Movie.fromJson(searchJson[i] as Map<String, dynamic>));
            }
          }
        }

        setState(() {
          searchResult = tempResult;
        });
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      // Handle network errors
      // You can display an error message to the user or perform other actions as needed
    }
  }

  Future<void> searchMoviesByCast(String val) async {
    try {
      var encodedName = Uri.encodeComponent(val); // Encode the actor's name
      var searchActorUrl =
          'https://api.themoviedb.org/3/search/person?api_key=${Constants.apiKey}&query=$encodedName&include_adult=false';
      var searchActorResponse = await http.get(Uri.parse(searchActorUrl));

      if (searchActorResponse.statusCode == 200) {
        var tempData = jsonDecode(searchActorResponse.body);
        var searchJson = tempData['results'];

        if (searchJson != null && searchJson.isNotEmpty) {
          List<Movie> tempResult = [];

          for (var actorData in searchJson) {
            if (actorData.containsKey('known_for')) {
              List<dynamic> knownFor = actorData['known_for'];
              tempResult.addAll(knownFor.map((json) => Movie.fromJson(json)));
            }
          }

          setState(() {
            searchResult = tempResult;
          });
        }
      } else {
        throw Exception('Failed to load search results');
      }
    } catch (e) {
      // Handle network errors
      // You can display an error message to the user or perform other actions as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showlist = !showlist;
      },
      child: Padding(
        padding:
            const EdgeInsets.only(left: 10.0, top: 30, bottom: 20, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.8),
                      borderRadius: const BorderRadius.all(Radius.circular(20))),
                  child: TextField(
                    autofocus: false,
                    controller: searchtext,
                    onChanged: (value) {
                      // Search when the text changes
                      searchlistfunction(value);
                    },
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 16, top: 16),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              searchtext.clear();
                              FocusManager.instance.primaryFocus?.unfocus();
                            });
                          },
                          icon: const Icon(
                            Icons.clear,
                            color: Colors.black,
                          ),
                        ),
                        hintText: 'Search movie',
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.8)),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(width: 10),
                // Dropdown for filter options
                DropdownButton<String>(
                  value: selectedFilter,
                  items: <String>['Title', 'Actor'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedFilter = newValue!;
                      // Clear the search results when the filter changes
                      searchResult.clear();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            searchResult.isNotEmpty
                ? SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5.0,
                        mainAxisSpacing: 15.0,
                      ),
                      itemCount: searchResult.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MovieDetailsScreen(
                                  movie: searchResult[index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500${searchResult[index].posterPath}',
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
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
