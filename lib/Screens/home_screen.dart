import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popcorn1/Screens/search_screen.dart';
import 'package:popcorn1/Widgets/searchBar.dart';
import '../Models/movie.dart';
import '../Widgets/slider widgets/movie_slider.dart';
import '../api/api.dart';
import '../widgets/slider widgets/trendingMovies_slider.dart';

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
              Column
              (
                children: 
                [
                  
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
                ]
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  // Navigate to the search screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                  );
                },
              ),
              //Cinema movies
              FutureBuilder
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
                    return MovieSlider
                    (
                      snapshot: snapshot,
                      categorytittle: "What's on cinema this week",
                      itemlength: snapshot.data!.length
                    );
                  }
                  else
                  {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(height: 32),
              //Highest grossing movies
              FutureBuilder
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
                    return MovieSlider
                    (
                      snapshot: snapshot,
                      categorytittle: "Highest grossing movies",
                      itemlength: snapshot.data!.length
                    );
                  }
                  else
                  {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const SizedBox(height: 32),
              //Children's movies
              FutureBuilder
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
                    return MovieSlider
                    (
                      snapshot: snapshot,
                      categorytittle: "Children's movies",
                      itemlength: snapshot.data!.length
                    );
                  }
                  else
                  {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        )
      )
    );
  }
}















