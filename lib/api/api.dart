import 'dart:convert';

import 'package:popcorn1/constants.dart';
import 'package:popcorn1/Models/movie.dart';
import 'package:http/http.dart' as http;

class Api
{
  static const _trendingUrl = 'https://api.themoviedb.org/3/movie/popular?api_key=${Constants.apiKey}';

  Future<List<Movie>> getTrendingMovies() async
  {
    final response = await http.get(Uri.parse(_trendingUrl));
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
}