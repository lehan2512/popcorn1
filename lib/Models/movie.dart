import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:popcorn1/constants.dart';

class Movie
{
  int id;
  String title;
  String backdropPath;
  String overview;
  String posterPath;
  String releaseDate;
  double voteAverage;
  bool adult;
  List<int> genreIds;
  List<String> genreNames;

  Movie
  (
    {
      required this.id,
      required this.title,
      required this.backdropPath,
      required this.overview,
      required this.posterPath,
      required this.releaseDate,
      required this.voteAverage,
      required this.adult,
      required this.genreIds,
      required this.genreNames,
    }
  );

  factory Movie.fromJson(Map<String, dynamic> json)
  {
    List<String> genres = extractGenreNames(List<int>.from(json['genre_ids']));
    
    return Movie
    (
      id: json["id"] as int,
      title: json["title"].toString(),
      backdropPath: json["backdrop_path"].toString(),
      overview: json["overview"].toString(),
      posterPath: json["poster_path"].toString(),
      releaseDate: json["release_date"].toString(),
      voteAverage: json["vote_average"] as double,
      adult: json["adult"] as bool,
      genreIds: List<int>.from(json['genre_ids']),
      genreNames: genres,
    );
  }

  static List<String> extractGenreNames(List<int> genreIds) {
    return genreIds.map((id) => GenreMapping.genreNames[id] ?? 'Unknown').toList();
  }
}

Future<List<String>> fetchMainCharacters(int movieId) async {
  final apiUrl = 'https://api.themoviedb.org/3/movie/$movieId/credits?api_key=${Constants.apiKey}';

  try {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> castList = data['cast'];

      // Filter and take the first 5 main characters based on a condition (e.g., significant role)
      final List<String> mainCharacters = castList
          .where((actor) => actor['known_for_department'] == 'Acting') // Adjust the condition as needed
          .take(5) // Limit to the first 5 names
          .map((actor) => actor['name'].toString())
          .toList();

      return mainCharacters;
    } else {
      throw Exception('Failed to load cast');
    }
  } catch (e) {
    throw Exception('Error fetching cast: $e');
  }
}

class GenreMapping {
  static Map<int, String> genreNames = 
  {
    28: 'Action',
    12: 'Adventure',
    16: 'Animation',
    35: 'Comedy',
    80: 'Crime',
    99: 'Documentary',
    18: 'Drama',
    10751: 'Family',
    14: 'Fantasy',
    36: 'History',
    27: 'Horror',
    10402: 'Music',
    9648: 'Mystery',
    10749: 'Romance',
    878: 'Science Fiction',
    10770: 'TV Movie',
    53: 'Thriller',
    10752: 'War',
    37: 'Western',
  };
}