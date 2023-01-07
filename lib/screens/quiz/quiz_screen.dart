import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/quiz/result_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../models/quiz.dart';


class QuizScreen extends StatefulWidget{

  QuizScreen({super.key});

  @override
  State<StatefulWidget> createState() => QuizScreenState();
}

class QuizScreenState extends State<QuizScreen>{
  Quiz quiz = Quiz();
  late Future<bool> done;
  @override
  void initState() {
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      backgroundColor: const Color(0xFF101010),
      title: AutoSizeText(
        S.of(context).BestQuizTitle,
        style: const TextStyle(fontSize: 30, color: Colors.lightGreen),
      ),
    );
    final _appBarHeight = _appBar.preferredSize.height;
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    final _height = _screenHeight - _statusBarHeight - _appBarHeight;
    final radius = min(_height * 0.5 * 0.25, _screenWidth * 0.25);

    return Scaffold(
        backgroundColor: const Color(0xFF101010),
        appBar: _appBar,
        body: Center(
          child: FutureBuilder<Quiz>(
            future: getBestQuiz(),
            builder: (BuildContext context, AsyncSnapshot<Quiz> snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done ){
                print("image"+quiz.image.toString());
                return Center(
                  child: Column(
                    children: [
                      SizedBox(height: _height * 0.2,),
                      AutoSizeText(
                        S.of(context).BestQuizScore,
                        style: const TextStyle(color: Colors.lightGreen,fontSize: 30,fontWeight: FontWeight.bold),),
                      Divider(height: _height * 0.03,),
                      AutoSizeText("${snapshot.data!.score}",
                        style: const TextStyle(color: Colors.lightGreen,fontSize: 40,fontWeight: FontWeight.bold),),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: const Color(0xFF101010),
                            minRadius: radius,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: radius - 10 > 0 ? radius - 10 : 5.0,
                              backgroundImage: Image.file(snapshot.data!.getFileImage()).image,
                            ),
                          ),
                          AutoSizeText("${snapshot.data!.position}",
                            style: const TextStyle(color: Colors.lightGreen,fontSize: 40,fontWeight: FontWeight.bold),),
                        ]
                      ),
                    ],

                  ),

                );
              }
              else
                return CircularProgressIndicator();
            }
          ),
        ),
    );
  }
}

Future<Quiz> getBestQuiz() async{
  var user = FirebaseAuth.instance.currentUser;
  final docRef = FirebaseFirestore.instance.collection("quiz").doc(
      user?.email);
  await docRef.get().then((DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    quiz.score = data["score"];
    quiz.username = data["username"];
    quiz.image = data["image"];
    quiz.position = data["position"];
  });

  return quiz;
}