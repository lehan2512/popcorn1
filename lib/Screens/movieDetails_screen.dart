import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popcorn1/Models/movie.dart';
import 'package:popcorn1/colours.dart';
import 'package:popcorn1/constants.dart';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Widgets/slider widgets/movie_slider.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetailsScreen> {
  late Future<List<Movie>> similarMovies;
  List<String> moviesGeneres = [];
  late String runTime = '';
  bool addToWatchlist = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? watchlistItemId; // Store the document ID in state

  Future<List<Movie>> getSimilarMovies() async {
    var _similarMoviesUrl =
        'https://api.themoviedb.org/3/movie/${widget.movie.id}/recommendations?api_key=${Constants.apiKey}&sort_by=popularity.desc';
    //https://api.themoviedb.org/3/movie/${widget.movie.id}/recommendations?api_key=${Constants.apiKey}&sort_by=popularity.desc

    try {
      final response = await http.get(Uri.parse(_similarMoviesUrl));
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body)['results'] as List;
        return decodedData.map((movie) => Movie.fromJson(movie)).toList();
      } else {
        print(
            'Failed to load similar movies. Status code: ${response.statusCode}');
        throw Exception('Failed to load similar movies');
      }
    } catch (error) {
      // Handle other types of errors
      print('Error fetching similar movies: $error');
      throw Exception('Error fetching similar movies');
    }
  }

  void _addToWatchList() async {
    if (!addToWatchlist) {
      // Get the current user
      User? user = _auth.currentUser;

      if (user != null) {
        // Save the movie to Firestore under the user's document
        DocumentReference documentReference = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('watchlist')
            .add({
          'movieId': widget.movie.id,
        });
        print('Watchlist item added. Document ID: ${documentReference.id}');

        setState(() {
          addToWatchlist = true;
          watchlistItemId = documentReference.id;
        });
      } else {
        print('User not authenticated');
      }
    }
  }

  Future<void> _removeFromWatchList() async {
    if (addToWatchlist && watchlistItemId != null) {
      User? user = _auth.currentUser;

      if (user != null) {
        // Remove the movie from Firestore
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('watchlist')
            .doc(watchlistItemId)
            .delete();

        // Clear the stored document ID
        setState(() {
          addToWatchlist = false;
          watchlistItemId = null;
        });

        print('Movie removed from watchlist');
      } else {
        print('User not authenticated');
      }
    }
  }

  @override
  void initState() {
    super.initState();
    similarMovies = getSimilarMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar.large(
          leading: Container(
            height: 70,
            width: 70,
            margin: const EdgeInsets.only(top: 16, left: 16),
            decoration: BoxDecoration(
                color: Colours.scaffoldBgColour,
                borderRadius: BorderRadius.circular(8)),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          ),
          backgroundColor: Colours.scaffoldBgColour,
          expandedHeight: 300,
          pinned: true,
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
                color: Colours.scaffoldBgColour.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  widget.movie.title,
                  style: GoogleFonts.aBeeZee(
                      fontSize: 16, fontWeight: FontWeight.w600),
                )),
            background: Image.network(
                '${Constants.imagePath}${widget.movie.backdropPath}',
                filterQuality: FilterQuality.high,
                fit: BoxFit.fitWidth),
          ),
        ),
        SliverToBoxAdapter(
            child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: SizedBox(
                        height: 38,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.movie.genreNames.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 82, 82, 82),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Text(
                                    widget.movie.genreNames[index],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ));
                            }),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Overview',
                      style: GoogleFonts.aBeeZee(
                          fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.movie.overview,
                      style: GoogleFonts.aBeeZee(
                          fontSize: 15, fontWeight: FontWeight.w400),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          'Cast: ',
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FutureBuilder(
                            future: fetchMainCharacters(widget.movie.id),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              } else if (snapshot.hasData) {
                                // Display the cast names
                                return Text(
                                  snapshot.data!.join(', '),
                                  style: GoogleFonts.roboto(
                                    fontSize: 12,
                                  ),
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(children: [
                      Text('Release date: ',
                          style: GoogleFonts.roboto(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(widget.movie.releaseDate,
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                          ))
                    ]),
                    const SizedBox(height: 5),
                    Row(children: [
                      Text('Vote average: ',
                          style: GoogleFonts.roboto(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(widget.movie.voteAverage.toStringAsFixed(1),
                          style: GoogleFonts.roboto(
                            fontSize: 12,
                          ))
                    ]),
                    const SizedBox(height: 20),
                    Center(
                      // Center the ElevatedButton
                      child: Container(
                        width: 300, // Set the width if you want a fixed width
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              addToWatchlist = !addToWatchlist;
                              if (addToWatchlist) {
                                _addToWatchList(); // Call the function to save the movie
                              } else {
                                _removeFromWatchList();
                              }
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colours.themeColour,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 16,
                            ),
                          ),
                          child: Text(
                            addToWatchlist
                                ? 'Added to WatchList'
                                : 'Add to WatchList',
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colours.scaffoldBgColour,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                        child: FutureBuilder(
                      future: similarMovies,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          return MovieSlider(
                              snapshot: snapshot,
                              categorytittle: "Similar movies",
                              itemlength: snapshot.data!.length);
                        } else {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                      },
                    )),
                  ],
                )))
      ],
    ));
  }
}
