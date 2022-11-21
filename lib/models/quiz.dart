import 'package:dima_project/models/answer.dart';
import 'package:dima_project/models/question.dart';
import 'package:dima_project/models/user.dart';

class Quiz {
  final String id;
  String genre;
  String author;
  final List<Question> questions;
  final User winner;
  final List<User> participants;

  Quiz({
    required this.id,
    this.genre = "",
    this.author = "",
    required this.questions,
    required this.winner,
    required this.participants
  });
}