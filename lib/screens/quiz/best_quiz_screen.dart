import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/customized_app_bar.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/quiz/result_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../models/quiz.dart';

class BestQuiz extends StatefulWidget {
  BestQuiz({super.key});

  @override
  State<StatefulWidget> createState() => BestQuizState();
}

class BestQuizState extends State<BestQuiz> {
  Quiz quiz = Quiz();
  late Future<bool> done;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = CustomizedAppBar(
        title: AutoSizeText(
          S.of(context).BestQuizTitle,
          style: TextStyle(fontSize: 30, color: Theme.of(context).textTheme.headline1?.color),
        ),
        leading: IconButton(
          key: const Key('arrow_back'),

          icon:
              Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
          onPressed: () {
            Navigator.pop(context);
          },
        ));
    Color? textColor = Theme.of(context).textTheme.headline1?.color;
    final _appBarHeight = _appBar.preferredSize.height;
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    final _height = _screenHeight - _statusBarHeight - _appBarHeight;
    final radius = min(_height * 0.5 * 0.25, _screenWidth * 0.25);

    return Scaffold(
      key: const Key('bestquiz_page'),
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: _appBar,
      body: FutureBuilder<Quiz>(
          future: getBestQuiz(),
          builder: (BuildContext context, AsyncSnapshot<Quiz> snapshot) {
            if (snapshot.hasData &&
                snapshot.connectionState == ConnectionState.done) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    S.of(context).BestQuizScore,
                    style: TextStyle(
                      fontSize: _screenWidth > _height
                          ? _screenWidth / 40
                          : _height / 25,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  AutoSizeText(
                    "${snapshot.data!.score}",
                    style: TextStyle(
                      fontSize: _screenWidth > _height
                          ? _screenWidth / 20
                          : _height / 15,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    minRadius: radius,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: radius - 10 > 0 ? radius - 10 : 5.0,
                      backgroundImage: isTest ? Image.asset(snapshot.data!.image!).image :
                          Image.file(snapshot.data!.getFileImage()).image,
                    ),
                  ),
                  AutoSizeText(
                    snapshot.data!.position,
                    style: TextStyle(
                      fontSize: _screenWidth > _height
                          ? _screenWidth / 40
                          : _height / 25,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: AutoSizeText(
                  S.of(context).NoQuizPresent,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                ),
              );
            }
          }),
    );
  }
}

Future<Quiz> getBestQuiz() async {
  var user = FirebaseAuth.instance.currentUser;
  final docRef = FirebaseFirestore.instance.collection("quiz").doc(user?.email);
  await docRef.get().then((DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    quiz.score = data["score"];
    quiz.username = data["username"];
    quiz.image = data["image"];
    quiz.position = data["position"];
  });

  return quiz;
}
