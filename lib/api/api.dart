import 'dart:convert';

import 'package:popcorn1/Models/TVshow.dart';
import 'package:popcorn1/constants.dart';
import 'package:popcorn1/Models/movie.dart';
import 'package:http/http.dart' as http;

class Api
{
  static const _trendingMoviesUrl=
  'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';

  static const _trendingTVUrl=
  'https://api.themoviedb.org/3/trending/tv/day?api_key=${Constants.apiKey}';

  Future<List<Movie>> getTrendingMovies() async
  {
    final response = await http.get(Uri.parse(_trendingMoviesUrl));
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

  Future<List<TV>> getTrendingTV() async
  {
    final response = await http.get(Uri.parse(_trendingTVUrl));
    if (response.statusCode == 200)
    {
      final decodedData = jsonDecode(response.body)['results'] as List;
      return decodedData.map((tvShow) => TV.fromJson(tvShow)).toList();
    }
    else
    {
      throw Exception('Something happened');
    }
  }
}