class TV
{
  String name;
  String backdropPath;
  String overview;
  String posterPath;
  String firstAirDate;
  double voteAverage;
  bool adult;

  TV
  (
    {
      required this.name,
      required this.backdropPath,
      required this.overview,
      required this.posterPath,
      required this.firstAirDate,
      required this.voteAverage,
      required this.adult,
    }
  );

  factory TV.fromJson(Map<String, dynamic> json)
  {
    return TV
    (
      name: json["name"] as String,
      backdropPath: json["backdrop_path"] as String,
      overview: json["overview"] as String,
      posterPath: json["poster_path"] as String,
      firstAirDate: json["first_air_date"] as String,
      voteAverage: json["vote_average"] as double,
      adult: json["adult"] as bool,
    );
  }
}