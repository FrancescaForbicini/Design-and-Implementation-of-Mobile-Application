import 'package:firebase_auth/firebase_auth.dart';

class Quiz {
  late int score;
  late String image;
  late User user;

  Future<String?> getImageQuiz () async {
    return image;
  }


}