import 'package:flutter/cupertino.dart';
import 'package:spotify/spotify.dart' as sp;

class Question{
  String question1 = "";
  String? artistAlbum = "";
  String question2 = "";
  Image image = Image.asset('images/wolf_user.png');
  bool isPresent = false;
  String url = "";
  String? rightAnswer = "";
  List<String> wrongAnswers = [];

}
