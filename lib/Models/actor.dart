class Actor
{
  int id;
  String name;
  String birthday;
  String biography;
  String profilePath;
  Actor
  (
    {
      required this.id,
      required this.name,
      required this.birthday,
      required this.biography,
      required this.profilePath,
    }
  );
  factory Actor.fromJson(Map<String, dynamic> json)
  {    
    return Actor
    (
      id: json["id"] as int,
      name: json["name"].toString(),
      birthday: json["birthday"].toString(),
      biography: json["biography"].toString(),
      profilePath: json["profile_path"].toString(),
    );
  }
}