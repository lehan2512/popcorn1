import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popcorn1/Models/movie.dart';
import 'package:popcorn1/colours.dart';
import 'package:popcorn1/constants.dart';
import 'package:http/http.dart' as http;

import '../Widgets/slider widgets/movie_slider.dart';

class MovieDetailsScreen extends StatefulWidget 
{
  final Movie movie;
  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetailsScreen>
{
  late Future<List<Movie>> similarMovies;
  List MoviesGeneres = [];

  Future<List<Movie>> getSimilarMovies() async
  {
    var _similarMoviesUrl = 'https://api.themoviedb.org/3/movie/${widget.movie.id}/similar?api_key=${Constants.apiKey}';

    final response = await http.get(Uri.parse(_similarMoviesUrl));
    if (response.statusCode == 200)
    {
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((movie) => Movie.fromJson(movie)).toList();
    }
    else
    {
      throw Exception('Something happened');
    }
  }

  @override
  void initState() {
    super.initState();
    similarMovies = getSimilarMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold
    (
      body: CustomScrollView
      (
        slivers: 
        [
          SliverAppBar.large
          (
            leading: Container
            (
              height: 70,
              width: 70,
              margin: const EdgeInsets.only
              (
                top: 16,
                left: 16
              ),
              decoration: BoxDecoration
              (
                color: Colours.scaffoldBgColour,
                borderRadius: BorderRadius.circular(8)
              ),
              child: IconButton
              (
                onPressed: ()
                {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios_new_rounded)
              ),
            ),
            backgroundColor: Colours.scaffoldBgColour,
            expandedHeight: 300,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar
            (
              title: Container
              (
                color: Colours.scaffoldBgColour.withOpacity(0.3),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text
                (
                  widget.movie.title,
                  style:GoogleFonts.aBeeZee
                  (
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                  ),
                )
              ),
              background: Image.network
              (
                '${Constants.imagePath}${widget.movie.backdropPath}',
                filterQuality: FilterQuality.high,
                fit: BoxFit.fitWidth
              ),
            ),
          ),
          SliverToBoxAdapter
          (
            child: Padding
            (
              padding: const EdgeInsets.all(12),
              child: Column
              (
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Text
                  (
                    'Overview',
                    style:GoogleFonts.aBeeZee
                    (
                      fontSize: 20,
                      fontWeight: FontWeight.w800
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text
                  (
                    widget.movie.overview,
                    style:GoogleFonts.aBeeZee
                    (
                      fontSize: 15,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row
                  (
                    children: 
                    [
                      Text
                      (
                        'Release date: ',
                        style: GoogleFonts.roboto
                        (
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text
                      (
                        widget.movie.releaseDate,
                        style: GoogleFonts.roboto
                        (
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ]
                  ),
                  const SizedBox(height: 5),
                  Row
                  (
                    children: 
                    [
                      Text
                      (
                        'Vote average: ',
                        style: GoogleFonts.roboto
                        (
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      Text
                      (
                        widget.movie.voteAverage.toStringAsFixed(1),
                        style: GoogleFonts.roboto
                        (
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                        )
                      )
                    ]
                  ),
                  const SizedBox(height: 32),
                  Text
                  (
                    "Similar Movies",
                    style: GoogleFonts.aBeeZee(fontSize: 20)
                  ),
                  const SizedBox(height: 10),
                  SizedBox
                  (
                    child: FutureBuilder
                    (
                      future: similarMovies,
                      builder:(context, snapshot) 
                      {
                        if (snapshot.hasError)
                        {
                          return Center
                          (
                            child: Text(snapshot.error.toString()),
                          );
                        }
                        else if(snapshot.hasData)
                        {
                          return MovieSlider(snapshot: snapshot,);
                        }
                        else
                        {
                          return const Center(child: CircularProgressIndicator());
                        }
                      },
                    )
                  ),
                ],
              )
            )
          )
        ],
      )
    );
  }
}