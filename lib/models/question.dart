import 'package:flutter/cupertino.dart';
import 'package:spotify/spotify.dart' as sp;

class Question{
  String question1 = "";
  String artist_album = "";
  String question2 = "";
  Image image = Image.asset('images/wolf_user.png');
  bool isPresent = false;
  sp.Track track = sp.Track();
  String right_answer = "";
  List<String> wrong_answer = [];

}
