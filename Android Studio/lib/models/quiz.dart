import 'dart:io';

class Quiz {
  int score = 0;
  String? image = "";
  String username = "";
  String position = "";
  String country = "";

  Future<String?> getImageQuiz () async {
    return image;
  }

  File getFileImage(){
    return File(image!);
  }
  Future<String?> getPosition() async{
    return position;
  }

  Future<String?> getCountry() async{
    return country;
  }


}