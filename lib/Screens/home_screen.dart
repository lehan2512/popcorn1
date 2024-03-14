import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:popcorn1/Screens/login_screen.dart';
import 'package:popcorn1/Screens/search_screen.dart';
import 'package:popcorn1/Widgets/slider%20widgets/movie_slider.dart';
import 'package:popcorn1/widgets/slider%20widgets/trendingMovies_slider.dart';
import '../Models/movie.dart';
import '../api/api.dart';
import 'package:connectivity/connectivity.dart'; // Import the connectivity package

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> trendingMovies;
  late Future<List<Movie>> cinemaMovies;
  late Future<List<Movie>> bestMovies;
  late Future<List<Movie>> grossingMovies;
  late Future<List<Movie>> childrensMovies;

  final user = FirebaseAuth.instance.currentUser!;

  //sign user out method
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  void initState() {
    super.initState();
    trendingMovies = fetchData(Api().getTrendingMovies);
    cinemaMovies = fetchData(Api().getCinemaMovies);
    bestMovies = fetchData(Api().getBestMovies);
    grossingMovies = fetchData(Api().getGrossingMovies);
    childrensMovies = fetchData(Api().getChildrensMovies);
  }

  Future<List<Movie>> fetchData(Future<List<Movie>> Function() apiCall) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // If no network connectivity, return an empty list
      return [];
    } else {
      // If there is network connectivity, make the API call
      return apiCall();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(
          'assets/popcorn(2).png',
          fit: BoxFit.cover,
          height: 40,
          filterQuality: FilterQuality.high,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trending movies',
                style: GoogleFonts.aBeeZee(fontSize: 20),
              ),
              Column(
                children: [
                  const SizedBox(height: 15),
                  FutureBuilder(
                    future: trendingMovies,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text(snapshot.error.toString()));
                      } else {
                        return TrendingMoviesSlider(snapshot: snapshot);
                      }
                    },
                  ),
                  const SizedBox(height: 32),
                ],
              ),
              Row(
                children: [
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
                  IconButton(
                    icon: Icon(Icons.logout),
                    onPressed: () {
                      signUserOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      ); // Go back to the login screen
                    },
                  ),
                ],
              ),
              //Cinema movies
              FutureBuilder(
                future: cinemaMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return MovieSlider(
                      snapshot: snapshot,
                      categorytittle: "What's on cinema this week",
                      itemlength: snapshot.data!.length,
                    );
                  } else {
                    return const Center(child: Text('No data available. Please refresh.'));
                  }
                },
              ),
              const SizedBox(height: 32),
              //Highest grossing movies
              FutureBuilder(
                future: grossingMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return MovieSlider(
                      snapshot: snapshot,
                      categorytittle: "Highest grossing movies of all time",
                      itemlength: snapshot.data!.length,
                    );
                  } else {
                    return const Center(child: Text('No data available. Please refresh.'));
                  }
                },
              ),
              const SizedBox(height: 32),
              //Best movies this year
              FutureBuilder(
                future: bestMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return MovieSlider(
                      snapshot: snapshot,
                      categorytittle: "Best movies this year",
                      itemlength: snapshot.data!.length,
                    );
                  } else {
                    return const Center(child: Text('No data available. Please refresh.'));
                  }
                },
              ),
              const SizedBox(height: 32),
              //Children's movies
              FutureBuilder(
                future: childrensMovies,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return MovieSlider(
                      snapshot: snapshot,
                      categorytittle: "Children's movies",
                      itemlength: snapshot.data!.length,
                    );
                  } else {
                    return const Center(child: Text('No data available. Please refresh.'));
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
