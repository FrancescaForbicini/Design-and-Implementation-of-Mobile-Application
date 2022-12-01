

import 'dart:convert';

import 'package:flutter/services.dart';

import 'answer.dart';


class Question{
  String topic = "";
  String name = "";
  String question1 = "";
  String artist_album = "";
  String question2 = "";
  List<Answer> options = <Answer>[];
  bool isLocked = false;
  Answer? selectedOption;

}

