import 'package:dima_project/models/question.dart';

class Answer{
  final String id;
  final String text;
  final Question questionRelated;
  final bool correct;

  Answer({
    required this.id,
    required this.text,
    required this.questionRelated,
    required this.correct,
  });

}