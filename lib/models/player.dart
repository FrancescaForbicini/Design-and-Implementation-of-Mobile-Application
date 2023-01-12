import 'dart:core';

import 'package:flutter/cupertino.dart';

class Player{
  late String username;
  late ImageProvider image;
  late String bestScore;
  late String email;
  late String location;

  Player();
  Player.create(this.username, this.bestScore, this.location);
}