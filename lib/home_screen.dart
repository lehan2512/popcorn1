import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Models/movie.dart';
import 'Models/TVshow.dart';
import 'api/api.dart';
import 'widgets/childrens_slider.dart';
import 'widgets/cinema_slider.dart';
import 'widgets/grossingMovies_slider.dart';
import 'widgets/grossingTV_slider.dart';
import 'widgets/trendingMovies_slider.dart';
import 'widgets/trendingTV_slider.dart';
import 'widgets/watched_slider.dart';

class HomeScreen extends StatefulWidget
{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  late Future<List<Movie>> trendingMovies;
  late Future<List<TV>> trendingTV;

  @override
  void initState()
  {
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    trendingTV = Api().getTrendingTV();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold
    (
      appBar: AppBar
      (
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset
        (
          'assets/popcorn(2).png',
          fit: BoxFit.cover,
          height: 40,
          filterQuality: FilterQuality.high,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView
      (
        physics: const BouncingScrollPhysics(),
        child: Padding
        (
          padding: const EdgeInsets.all(8.0),
          child: Column
          (
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
            [
              Text
              (
                'Trending movies',
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
              const SizedBox(height: 15),
              SizedBox
              (
                child: FutureBuilder
                (
                  future: trendingMovies,
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
                      return TrendingMoviesSlider(snapshot: snapshot,);
                    }
                    else
                    {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ),
              const SizedBox(height: 32),
              Text
              (
                'Trending TV shows',
                style: GoogleFonts.aBeeZee(fontSize: 20)
              ),
              const SizedBox(height: 10),
              SizedBox
              (
                child: FutureBuilder
                (
                  future: trendingTV,
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
                      return TrendingTVSlider(snapshot: snapshot,);
                    }
                    else
                    {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                )
              ),
              const SizedBox(height: 32),
              Text
              (
                "What's on cinema this week",
                style: GoogleFonts.aBeeZee(fontSize: 20)
              ),
              const SizedBox(height: 10),
              const CinemaSlider(),
              const SizedBox(height: 32),
              Text
              (
                "Highest grossing movies",
                style: GoogleFonts.aBeeZee(fontSize: 20)
              ),
              const SizedBox(height: 10),
              GrossingMoviesSlider(),
              const SizedBox(height: 32),
              Text
              (
                "Highest grossing TV shows",
                style: GoogleFonts.aBeeZee(fontSize: 20)
              ),
              const SizedBox(height: 10),
              const GrossingTVSlider(),
              const SizedBox(height: 32),
              Text
              (
                "Childrens movies",
                style: GoogleFonts.aBeeZee(fontSize: 20)
              ),
              const SizedBox(height: 10),
              const ChildrensSlider(),
              const SizedBox(height: 32),
              Text
              (
                "Watched again",
                style: GoogleFonts.aBeeZee(fontSize: 20)
              ),
              const SizedBox(height: 10),
              const WatchedSlider(),
            ],
          ),
        )
      )
    );
  }
}















