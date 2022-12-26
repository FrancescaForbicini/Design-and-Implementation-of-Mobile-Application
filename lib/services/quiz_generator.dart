import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:dima_project/services/questions_artist.dart';
import 'package:dima_project/services/questions_playlist.dart';
import 'package:dima_project/services/result_page.dart';
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
  final int level;
  const QuizGenerator(this.topic, this.typeQuiz, this.totalScore,this.level);

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
      body: QuizGeneratorStateful(topic, typeQuiz, totalScore,level),
    );
  }
}

class QuizGeneratorStateful extends StatefulWidget {
  final topic;
  final String typeQuiz;
  final int totalScore;
  final int level;

  QuizGeneratorStateful(this.topic, this.typeQuiz,this.totalScore,this.level);

  @override
  _QuizGeneratorState createState() => _QuizGeneratorState(topic, typeQuiz,totalScore,level);
}

class _QuizGeneratorState extends State<QuizGeneratorStateful> {
  final topic;
  int totalScore;
  int level;
  final String typeQuiz;
  AudioPlayer audioPlayer = AudioPlayer();
  late List<Question> _questions;
  late PageController _controller;
  List _questionsFromJSON = [];
  bool end = false;
  int _questionNumber = 1;
  late Future<bool> _done;


  _QuizGeneratorState(this.topic, this.typeQuiz, this.totalScore,this.level);

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
          _questions = [];
          await QuestionsArtist().buildQuestionArtists(
              _questions, topic, _questionsFromJSON);
          break;
        }
      default:
        {
          print("Neither Playlist or Artist was selected");
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
      child: Flex(
      direction: Axis.horizontal,
      children: [
        FutureBuilder(
            future: _done,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                return quizBuilder();
              }
              else {
                return const Center(
                  //TODO parametrizzare
                  widthFactor: 9,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightGreen,

                  ),
                );
              }
            }),
      ],
    ),);
  }

  Widget quizBuilder() {
    return Expanded(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "Score: $totalScore   Level: $level",
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
                        answerBackgroundColor: const Color(0xFF101010),
                        questionColor: const Color(0xFF101010),
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
                            totalScore = (totalScore + 1) * level;
                          }),
                          onRightQuestion(),
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


  void onRightQuestion() async{
    _controller.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInExpo,
    );
    if (_questionNumber < _questions.length) {

      setState(() {
        _questionNumber++;
      });
    } else {
      setState(() {
        level ++;
        _questions = [];
      });
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text('You succeed $_questionNumber questions!', style: const TextStyle(color: Color(0xFF101010), fontWeight: FontWeight.bold, fontSize: 20),),
          content: Text('Press the button GoOn to go to the level $level\n'
              'Otherwise press the button Exit\n',
                style: const TextStyle(color: Color(0xFF101010), fontWeight: FontWeight.bold, fontSize: 20,)),
          backgroundColor: Colors.lightGreenAccent,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF101010),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Go On',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuizGenerator(
                            topic,typeQuiz,totalScore,level),
                  ),
                );
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF101010),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Exit',style: TextStyle(color: Colors.white),),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ResultPage(
                            score: totalScore,
                            end: end),
                  ),
                );

              },
            ),
          ],
        );
      },
      );

    }
  }
}


