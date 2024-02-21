import 'dart:convert';
import 'package:popcorn1/constants.dart';
import 'package:popcorn1/Models/movie.dart';
import 'package:http/http.dart' as http;

class Api
{
  static const _trendingMoviesUrl=
  'https://api.themoviedb.org/3/trending/movie/day?api_key=${Constants.apiKey}';

  static const _cinemaUrl=
  'https://api.themoviedb.org/3/movie/now_playing?api_key=${Constants.apiKey}';

  static const _grossingMoviesUrl=
  'https://api.themoviedb.org/3/movie/top_rated?api_key=${Constants.apiKey}';

  static const _childrensUrl=
  'https://api.themoviedb.org/3/discover/movie?api_key=${Constants.apiKey}&adult=false&with_genres=16';

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

  Future<List<Movie>> getCinemaMovies() async
  {
    final response = await http.get(Uri.parse(_cinemaUrl));
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

  Future<List<Movie>> getGrossingMovies() async
  {
    final response = await http.get(Uri.parse(_grossingMoviesUrl));
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

  Future<List<Movie>> getChildrensMovies() async
  {
    final response = await http.get(Uri.parse(_childrensUrl));
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