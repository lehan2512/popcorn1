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
    }
  );

  factory Movie.fromJson(Map<String, dynamic> json)
  {
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
    );
  }
}

