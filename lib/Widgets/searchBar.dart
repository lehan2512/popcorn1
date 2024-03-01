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

  Future<void> searchlistfunction(val) async {
    if (val.isEmpty) {
      // If search text is empty, don't make the API call
      return;
    }

    var searchurl =
        'https://api.themoviedb.org/3/search/multi?api_key=${Constants.apiKey}&query=$val&include_adult=false';
    var searchresponse = await http.get(Uri.parse(searchurl));
    if (searchresponse.statusCode == 200) {
      var tempdata = jsonDecode(searchresponse.body);
      var searchjson = tempdata['results'];

      List<Movie> tempResult = [];
      for (var i = 0; i < searchjson.length; i++) {
        if (searchjson[i]['media_type'] == 'movie') {
          if (searchjson[i]['id'] != null &&
              searchjson[i]['title'] != null &&
              searchjson[i]['poster_path'] != null &&
              searchjson[i]['vote_average'] != null &&
              searchjson[i]['media_type'] != null) {
            tempResult.add(Movie.fromJson(searchjson[i] as Map<String, dynamic>));
          }
        }
      }

      setState(() {
        searchResult = tempResult;
      });
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
        padding: const EdgeInsets.only(left: 10.0, top: 30, bottom: 20, right: 10),
        child: Column(
          children: [
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
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
                    contentPadding: EdgeInsets.only(left: 16, top: 16),
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
                    hintText: 'search movie',
                    hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                    border: InputBorder.none),
              ),
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
                            decoration: BoxDecoration(
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
