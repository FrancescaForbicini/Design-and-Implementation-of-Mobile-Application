import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/settings/acquire_image.dart';
import 'package:dima_project/screens/settings/acquire_position.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../generated/l10n.dart';
import '../../models/quiz.dart';
import '../../services/spotify_service.dart';
import '../profile/userprofile_screen.dart';

Quiz quiz = Quiz();

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.score, required this.end});

  final int score;
  final bool end;

  @override
  State<StatefulWidget> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  String? image;
  List<String>? position;
  var username;
  late int bestScore;
  late Future<bool> done;
  late bool savedPicture;
  late bool savedPosition;
  Color? backgroundColor;
  Color? buttonColor;

  @override
  void initState() {
    done = getBestScore();
    savedPicture = false;
    savedPosition = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    final _height = _screenHeight - _statusBarHeight;
    final radius = min(_height * 0.5 * 0.25, _screenWidth * 0.25);

    backgroundColor = Theme.of(context).backgroundColor;
    buttonColor = Theme.of(context).buttonColor;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: FutureBuilder(
          future: done,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.end)
                    AutoSizeText(
                      S.of(context).ResultTitle,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1?.color,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  AutoSizeText(
                    S.of(context).ResultMessage(widget.score),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1?.color,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  if (bestScore < widget.score) ...[
                    savePicture(_height, _screenWidth, radius),
                    savePosition(_height, _screenWidth, radius),
                  ] else
                    exitButton(),
                  savedPicture && savedPosition ? exitButton() : Container(),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              );
            }
          }),
    );
  }

  Widget savePicture(double _height, double _screenWidth, double radius) {
    updateScore(widget.score);
    return GestureDetector(
      onTap: () async {
        image = (await AcquireImage().getImageFromCamera())!;
        if (image != null) {
          setState(() {
            quiz.image = image!;
            savedPicture = true;
          });
        }
      },
      child: FutureBuilder<String?>(
          future: quiz.getImageQuiz(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (image != null) {
              File file = File(image!);
              return CircleAvatar(
                backgroundColor: Theme.of(context).buttonColor,
                minRadius: radius,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: radius - 10 > 0 ? radius - 10 : 5.0,
                  backgroundImage: Image.file(file).image,
                ),
              );
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: buttonColor,
                  margin: EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  constraints: BoxConstraints.expand(
                      height: _height / 16, width: _screenWidth / 2),
                  child: AutoSizeText(
                    S.of(context).ResultPicture,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(
                  key: const Key("camera_button"),

                  Icons.photo_camera,
                  color: buttonColor,
                  size: _height / 16,
                ),
              ],
            );
          }),
    );
  }

  Widget savePosition(double _height, double _screenWidth, double radius) {
    {
      return GestureDetector(
        onTap: () async {
          position = await AcquirePosition().getPosition();
          if (position != null) {
            setState(() {
              quiz.country = position![0];
              quiz.position = position![1];
              savedPosition = true;
            });
          }
        },
        child: FutureBuilder<String?>(
            future: quiz.getPosition(),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              if (position != null) {
                return Container(
                  color: buttonColor,
                  margin: EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  constraints: BoxConstraints.expand(
                      height: _height / 16, width: _screenWidth / 2),
                  child: AutoSizeText(
                    snapshot.data!.toString(),
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                );
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: buttonColor,
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    constraints: BoxConstraints.expand(
                        height: _height / 16, width: _screenWidth / 2),
                    child: AutoSizeText(
                      S.of(context).ResultPosition,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Icon(
                    key: const Key("location_button"),

                    Icons.location_on,
                    color: buttonColor,
                    size: _height / 16,
                  ),
                ],
              );
            }),
      );
    }
  }

  Widget exitButton() {
    return ElevatedButton(
      key: const Key("exit_button"),
      style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
              (states) =>  buttonColor!)),
      onPressed: () => {
        Navigator.pop(context),
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => UserProfile()))
      },
      child: AutoSizeText(
        S.of(context).ResultButton,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Future<bool> getBestScore() async {
    var _user = FirebaseAuth.instance.currentUser;
    var _data;
    var _bestScore;
    final docRef =
        FirebaseFirestore.instance.collection("users").doc(_user?.email);
    await docRef.get().then((DocumentSnapshot doc) {
      _data = doc.data() as Map<String, dynamic>;
      _bestScore = _data["bestScore"];
    });
    if (_bestScore == null) {
      bestScore = 0;
    }
    bestScore = _bestScore;
    return true;
  }

  Future<void> updateScore(int score) async {
    var user = FirebaseAuth.instance.currentUser;

    final docRef =
        FirebaseFirestore.instance.collection("users").doc(user?.email);
    docRef.update({
      "bestScore": score,
    });
    var data = await docRef.get();
    var username = data['username'];

    final docQuiz =
        FirebaseFirestore.instance.collection("quiz").doc(user?.email);
    docQuiz.set({
      "username": username,
      "score": score,
      "image": image,
      "country": position![0],
      "position": position![1],
    });
  }
}
