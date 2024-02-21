import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Models/movie.dart';
import '../api/api.dart';
import '../widgets/slider widgets/childrens_slider.dart';
import '../widgets/slider widgets/cinema_slider.dart';
import '../widgets/slider widgets/grossingMovies_slider.dart';
import '../widgets/slider widgets/trendingMovies_slider.dart';
import '../widgets/slider widgets/watched_slider.dart';

class HomeScreen extends StatefulWidget
{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
{
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> cinemaMovies;
  late Future<List<Movie>> grossingMovies;
  late Future<List<Movie>> childrensMovies;

  @override
  void initState()
  {
    super.initState();
    trendingMovies = Api().getTrendingMovies();
    cinemaMovies = Api().getCinemaMovies();
    grossingMovies = Api().getGrossingMovies();
    childrensMovies = Api().getChildrensMovies();
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
                "What's on cinema this week",
                style: GoogleFonts.aBeeZee(fontSize: 20)
              ),
              const SizedBox(height: 10),
              SizedBox
              (
                child: FutureBuilder
                (
                  future: cinemaMovies,
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
                      return CinemaSlider(snapshot: snapshot,);
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
                "Highest grossing movies",
                style: GoogleFonts.aBeeZee(fontSize: 20)
              ),
              const SizedBox(height: 10),
              SizedBox
              (
                child: FutureBuilder
                (
                  future: grossingMovies,
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
                      return GrossingMoviesSlider(snapshot: snapshot,);
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
                "Childrens movies",
                style: GoogleFonts.aBeeZee(fontSize: 20)
              ),
              const SizedBox(height: 10),
              SizedBox
              (
                child: FutureBuilder
                (
                  future: childrensMovies,
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
                      return ChildrensSlider(snapshot: snapshot,);
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















