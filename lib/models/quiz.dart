
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class Quiz {
  int score = 0;
  String? image = "";
  String username = "";
  String position = "";

  Future<String?> getImageQuiz () async {
    return image;
  }

  File getFileImage(){
    return File(image!);
  }


}