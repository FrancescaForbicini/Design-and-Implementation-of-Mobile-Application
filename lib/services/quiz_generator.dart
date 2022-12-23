import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/services/questions_artist.dart';
import 'package:dima_project/services/questions_playlist.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quiz_view/quiz_view.dart';

import '../models/question.dart';

class QuizGenerator extends StatelessWidget {
  final topic;
  final String typeQuiz;
  final int totalScore;

  const QuizGenerator(this.topic, this.typeQuiz, this.totalScore);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF101010),
        title: const Text(
          "New Quiz",
          style: TextStyle(color: Colors.lightGreen, fontSize: 35),
        ),
      ),
      body: QuizGeneratorStateful(topic, typeQuiz, totalScore),
    );
  }
}

class QuizGeneratorStateful extends StatefulWidget {
  final topic;
  final String typeQuiz;
  final int totalScore;

  QuizGeneratorStateful(this.topic, this.typeQuiz,this.totalScore);

  @override
  _QuizGeneratorState createState() => _QuizGeneratorState(topic, typeQuiz,totalScore);
}

class _QuizGeneratorState extends State<QuizGeneratorStateful> {
  final topic;
  int totalScore;
  final String typeQuiz;
  AudioPlayer audioPlayer = AudioPlayer();
  late List<Question> _questions;
  late PageController _controller;
  List _questionsFromJSON = [];
  bool end = false;
  int _questionNumber = 1;
  late Future<bool> _done;


  _QuizGeneratorState(this.topic, this.typeQuiz, this.totalScore);

  // Fetch content from the json file
  Future<bool> readJson() async {
    final String response = await rootBundle
        .loadString('json/question_$typeQuiz.json');
    final data = await json.decode(response);
    setState(() {
      _questionsFromJSON = data["questions"];
    });
    switch (typeQuiz) {
      case 'playlists':
        {
          _questions = [];
          await QuestionsPlaylist().buildQuestionsPlaylist(
              _questions, topic, _questionsFromJSON);
          break;
        }

      case 'artists':
        {
          await QuestionsArtist().buildQuestionArtists(
              _questions, topic, _questionsFromJSON);
          break;
        }
      default:
        {
          print("error");
          break;
        }
    }

    return true;
  }


  @override
  void initState() {
    _done = readJson();

    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightGreen,
      padding: const EdgeInsets.all(25),
      child: Column(children: [
        FutureBuilder(
            future: _done,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                return quizBuilder();
              }
              else {
                return Container();
              }
            })
      ]),
    );
  }

  Widget quizBuilder() {
    return Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Score: $totalScore",
                style: const TextStyle(
                    color: Color(0xFF101010),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 1, color: Colors.grey),
              Expanded(
                  child: PageView.builder(
                    itemCount: _questions.length,
                    controller: _controller,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      print(_questions[index].rightAnswer);

                      double h, w;
                      h = 0;
                      w = 0;
                      if (_questions[index].isPresent) {
                        h = 300;
                        w = 300;
                      }
                      return QuizView(
                        image: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            child: Ink.image(
                              width: w * 0.2,
                              height: h * 0.2,
                              image: _questions[index].image.image,
                            ),
                            onTap: () async {
                              print(_questions[index].url);

                              await audioPlayer.setUrl(
                                  _questions[index].url);
                              await audioPlayer.play();
                            },
                          ),
                        ),
                        showCorrect: true,
                        answerColor: Colors.white,
                        answerBackgroundColor: Color(0xFF101010),
                        questionColor: Color(0xFF101010),
                        backgroundColor: Colors.lightGreen,
                        width: 600,
                        height: 700,
                        question: _questions[index].question1 +
                            _questions[index].artistAlbum.toString() +
                            _questions[index].question2,
                        rightAnswer: _questions[index].rightAnswer,
                        wrongAnswers: [
                          _questions[index].wrongAnswers[0],
                          _questions[index].wrongAnswers[1],
                          _questions[index].wrongAnswers[2]
                        ],
                        onRightAnswer: () =>
                        {
                          audioPlayer.stop(),
                          setState(() {
                            totalScore = totalScore + 1;
                          }),
                          buildElevatedButton(totalScore,index),
                        },
                        onWrongAnswer: () =>
                        {
                          audioPlayer.stop(),
                          setState(() {
                            end = true;
                            Timer(const Duration(milliseconds: 500), () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ResultPage(
                                        score: totalScore,
                                        end: end,
                                      ),
                                ),
                              );
                            });
                          })
                        },
                      );
                    },
                  ))
            ]));
  }


  void buildElevatedButton(int score, int index) async{
    if (_questionNumber < _questions.length) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInExpo,
      );
      setState(() {
        _questionNumber++;
      });
    } else {
      _questions = [];
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QuizGenerator(
                  topic,typeQuiz,totalScore),
        ),
      );

    }
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final bool end;

  const ResultPage(
      {Key? key, required this.score, required this.end})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightGreen,
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 300,
              ),
              if (end) Text("You missed a question!"),
              Text(
                'You got $score',
                style: const TextStyle(
                    color: Color(0xFF101010),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const Divider(
                height: 20,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => const Color(0xFF101010))),
                onPressed: () => {
                  updateScore(score),
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserProfile()))
                },
                child: const Text(
                  "Exit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}

Future<void> updateScore(int score) async {
  var user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> data;
  var bestScore;
  final docRef =
      FirebaseFirestore.instance.collection("users").doc(user?.email);
  docRef.get().then((DocumentSnapshot doc) {
    data = doc.data() as Map<String, dynamic>;
    bestScore = data["bestScore"];
    if (bestScore < score) {
      docRef.update({
        "bestScore": score,
      });
    }
  }, onError: (e) => print("Error getting document: $e"));
}
