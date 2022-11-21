class User {
  final String id;
  final String name;
  final String surname;
  final String email;
  int followers;
  int following;
  //TODO playlist
  //TODO quiz

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
    this.followers = 0,
    this.following = 0,
    //TODO playlist
    //TODO quiz
  });
}