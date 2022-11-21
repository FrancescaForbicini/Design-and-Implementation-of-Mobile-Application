import 'package:dima_project/models/user.dart';

class Quiz {
  final String id;
  String genre;
  String author;
  final List<String> questions;
  final List<String> answers;
  final User winner;
  final List<User> participants;

  Quiz({
    required this.id,
    this.genre = "",
    this.author = "",
    required this.questions,
    required this.answers,
    required this.winner,
    required this.participants
  });
}