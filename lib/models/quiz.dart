import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class Quiz {
  late int score;
  late String image;
  late User user;
  Position? position;

  Future<String?> getImageQuiz () async {
    return image;
  }


}