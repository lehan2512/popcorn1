import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:popcorn1/Screens/login_screen.dart';
import 'package:popcorn1/Screens/search_screen.dart';
import 'package:popcorn1/Widgets/slider%20widgets/movie_slider.dart';
import 'package:popcorn1/Widgets/slider%20widgets/tv_slider.dart';
import 'package:popcorn1/colours.dart';
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
  late Future<List<Movie>> onTvTonight;
  late Future<List<Movie>> bestMovies;
  late Future<List<Movie>> grossingMovies;
  late Future<List<Movie>> childrensMovies;
    late Future<List<Movie>> sinhalaMovies;


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
    onTvTonight = fetchData(Api().getOnTvTonight);
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

  void resetToInitialState() {
    setState(() {
      trendingMovies = fetchData(Api().getTrendingMovies);
      cinemaMovies = fetchData(Api().getCinemaMovies);
      onTvTonight = fetchData(Api().getOnTvTonight);
      bestMovies = fetchData(Api().getBestMovies);
      grossingMovies = fetchData(Api().getGrossingMovies);
      childrensMovies = fetchData(Api().getChildrensMovies);
    });
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
          height: 50,
          filterQuality: FilterQuality.high,
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      user.email ?? '',
                      style: const TextStyle(color: Colors.black),
                    ),
                    accountEmail: null, // If you don't want to display email
                    decoration: const BoxDecoration(
                      color: Colours
                          .themeColour, // Change background color to yellow
                    ),
                    currentAccountPicture: CircleAvatar(
                      child: Image.asset('assets/popcorn.png'),
                    ),
                  ),
                  ListTile(
                    title: const Center(child: Text('My WatchList')),
                    onTap: () {
                      // Navigate to the watchlist screen
                    },
                  ),
                ],
              ),
            ),
            const Divider(),
            ListTile(
              title: const Center(child: Text('Logout')),
              onTap: () {
                signUserOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ); // Go back to the login screen
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                      categorytittle: "What's on cinema this week>",
                      itemlength: snapshot.data!.length,
                    );
                  } else {
                    return const Center(
                        child: Text('No data available. Please refresh.'));
                  }
                },
              ),
              const SizedBox(height: 32),
              //Children's movies
              FutureBuilder(
                future: onTvTonight,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.hasData) {
                    return TvShowSlider(
                      snapshot: snapshot,
                      categorytittle: "What's on TV tonight>",
                      itemlength: snapshot.data!.length,
                    );
                  } else {
                    return const Center(
                        child: Text('No data available. Please refresh.'));
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
                      categorytittle: "Highest grossing movies>",
                      itemlength: snapshot.data!.length,
                    );
                  } else {
                    return const Center(
                        child: Text('No data available. Please refresh.'));
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
                      categorytittle: "Best movies this year>",
                      itemlength: snapshot.data!.length,
                    );
                  } else {
                    return const Center(
                        child: Text('No data available. Please refresh.'));
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
                      categorytittle: "Children's movies>",
                      itemlength: snapshot.data!.length,
                    );
                  } else {
                    return const Center(
                        child: Text('No data available. Please refresh.'));
                  }
                },
              ),
            ],
          ),
        ),
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
                resetToInitialState();
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
          ],
        ),
      ),
    );
  }
}
