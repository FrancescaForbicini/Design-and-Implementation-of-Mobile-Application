import 'package:dima_project/models/quiz.dart';

class User {
  final String id;
  final String name;
  final String surname;
  final String email;
  final String username;
  final List<User> followers = [];
  final List<User> following = [];
  //TODO final List<Quiz> quiz;
  //TODO playlist

  User({
    required this.id,
    required this.name,
    required this.surname,
    required this.username,
    required this.email,
    //TODO required this.quiz,
    //TODO playlist
  });
}