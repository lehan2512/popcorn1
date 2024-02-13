class Movie
{
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
      required this.title,
      required this.backdropPath,
      required this.overview,
      required this.posterPath,
      required this.releaseDate,
      required this.voteAverage,
      required this.adult,
    }
  );
}

