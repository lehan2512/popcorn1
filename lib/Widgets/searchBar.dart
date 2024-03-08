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
  String selectedFilter = 'Title'; // Default filter option

  Future<void> searchlistfunction(String val) async {
    if (val.isEmpty) {
      // If search text is empty, don't make the API call
      return;
    }

    if (selectedFilter == 'Title') {
      await searchMoviesByTitle(val);
    } else if (selectedFilter == 'Cast') {
      await searchMoviesByCast(val);
    }
  }

  Future<void> searchMoviesByActor(int actorId) async {
  var moviesByActorUrl =
      'https://api.themoviedb.org/3/person/$actorId/movie_credits?api_key=${Constants.apiKey}';
  var moviesByActorResponse = await http.get(Uri.parse(moviesByActorUrl));

  if (moviesByActorResponse.statusCode == 200) {
    var tempData = jsonDecode(moviesByActorResponse.body);
    var searchJson = tempData['cast'];

    List<Movie> tempResult = [];
    for (var i = 0; i < searchJson.length; i++) {
      if (searchJson[i]['id'] != null &&
          searchJson[i]['title'] != null &&
          searchJson[i]['poster_path'] != null &&
          searchJson[i]['vote_average'] != null &&
          searchJson[i]['media_type'] == 'movie') {
        tempResult.add(Movie.fromJson(searchJson[i] as Map<String, dynamic>));
      }
    }

    setState(() {
      searchResult = tempResult;
    });
  } else {
    // Handle error when fetching movies by actor
    print('Error fetching movies by actor: ${moviesByActorResponse.statusCode}');
  }
}

Future<List<String>> getActorSuggestions(String query) async {
  var actorSuggestionsUrl =
      'https://api.themoviedb.org/3/search/person?api_key=${Constants.apiKey}&query=$query&include_adult=false';
  var actorSuggestionsResponse = await http.get(Uri.parse(actorSuggestionsUrl));

  if (actorSuggestionsResponse.statusCode == 200) {
    var tempData = jsonDecode(actorSuggestionsResponse.body);
    var searchJson = tempData['results'];

    List<String> suggestions = searchJson
        .where((result) => result['media_type'] == 'person')
        .map<String>((result) => result['name'] as String)
        .toList();

    return suggestions;
  } else {
    // Handle error when fetching actor suggestions
    print('Error fetching actor suggestions: ${actorSuggestionsResponse.statusCode}');
    return [];
  }
}

  Future<void> searchMoviesByTitle(String val) async {
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
            tempResult.add(Movie.fromJson(searchJson[i] as Map<String, dynamic>));
          }
        }
      }

      setState(() {
        searchResult = tempResult;
      });
    }
  }

  Future<void> searchMoviesByCast(String val) async {
  // Add logic to get actor suggestions and display them
  List<String> actorSuggestions = await getActorSuggestions(val);
  print('Actor Suggestions: $actorSuggestions');
  // Implement logic to show actor suggestions in your UI
  // (e.g., use a ListView.builder to display suggestions)

  // When an actor is selected (e.g., on suggestion tap), call the searchMoviesByActor method
  // Example: onTap: () => searchMoviesByActor(actorId),
  // Note: Ensure you have a way to get the actorId from the selected suggestion.
}



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showlist = !showlist;
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 30, bottom: 20, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width - 100,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.8),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: TextField(
                    autofocus: false,
                    controller: searchtext,
                    onSubmitted: (value) {
                      // Search only when the text is submitted
                      searchlistfunction(value);
                    },
                    onChanged: (value) {
                      // Search when the text changes
                      searchlistfunction(value);
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 16, top:16),
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
                        hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                        border: InputBorder.none),
                  ),
                ),
                const SizedBox(width: 10),
                // Dropdown for filter options
                DropdownButton<String>(
                  value: selectedFilter,
                  items: <String>['Title', 'Cast'].map((String value) {
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
                ? Container(
  height: MediaQuery.of(context).size.height - 200,
  child: GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3, // Number of columns
      crossAxisSpacing: 15.0, // Spacing between columns
      mainAxisSpacing: 10.0, // Spacing between rows
      childAspectRatio: 0.7, // Adjust as needed
    ),
    itemCount: searchResult.length,
    physics: BouncingScrollPhysics(),
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
          decoration: const BoxDecoration(
            color: Color.fromRGBO(20, 20, 20, 1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(
                      'https://image.tmdb.org/t/p/w500${searchResult[index].posterPath}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                height: 158, // Adjust as needed
                width: double.infinity,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  child: Text(
                    '${searchResult[index].title}',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ),
            ],
          ),
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
