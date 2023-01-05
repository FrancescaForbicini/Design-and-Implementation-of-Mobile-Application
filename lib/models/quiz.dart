import 'dart:io';

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
  Future<String?> getPosition() async{
    return position;
  }


}