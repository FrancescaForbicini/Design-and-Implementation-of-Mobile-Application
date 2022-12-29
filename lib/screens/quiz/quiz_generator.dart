import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dima_project/services/questions_artist.dart';
import 'package:dima_project/services/questions_playlist.dart';
import 'package:dima_project/screens/quiz/result_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quiz_view/quiz_view.dart';

import '../../models/question.dart';

class QuizGenerator extends StatelessWidget {
  final topic;
  final String typeQuiz;
  final int totalScore;
  final int level;
  const QuizGenerator(this.topic, this.typeQuiz, this.totalScore,this.level, {super.key});

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      backgroundColor: const Color(0xFF101010),
      title: const AutoSizeText(
        "New Quiz",
        style: TextStyle(color: Colors.lightGreen, fontSize: 30),
      ),
    );
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _appBarHeight = _appBar.preferredSize.height;
    final _statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: _appBar,
      body: QuizGeneratorStateful(topic, typeQuiz, totalScore, level, _screenWidth, _screenHeight - _appBarHeight - _statusBarHeight),
    );
  }
}

class QuizGeneratorStateful extends StatefulWidget {
  final topic;
  final String typeQuiz;
  final int totalScore;
  final int level;
  final width;
  final height;

  QuizGeneratorStateful(this.topic, this.typeQuiz, this.totalScore, this.level, this.width, this.height);

  @override
  _QuizGeneratorState createState() => _QuizGeneratorState(topic, typeQuiz, totalScore, level, width, height);
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
  final width;
  final height;

  _QuizGeneratorState(this.topic, this.typeQuiz, this.totalScore, this.level, this.width, this.height);

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
      width: width,
      height: height,
      color: Color (0xFF101010),
      //padding: const EdgeInsets.all(25),
      child: FutureBuilder(
          future: _done,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              return quizBuilder();
            }
            else {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.lightGreen,
                ),
              );
            }
          }
      ),

    );
  }

  Widget quizBuilder() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: width,
            height: height * 0.01,
          ),
          AutoSizeText(
            "Score: $totalScore   Level: $level",
            textAlign: TextAlign.end,
            style: const TextStyle(
                color: Colors.lightGreen,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: width,
            height: height * 0.01,
          ),
          Container(
            width: width * 0.9,
            height: height * 0.9,
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
                  h = height * 0.9 * 0.15;
                  w = height * 0.9 * 0.15;
                }
                return QuizView(
                  image: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      child: Ink.image(
                        width: w,
                        height: h,
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
                  width: width * 0.9,
                  height: height * 0.9,
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
            )
          )
        ]
    );
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
          title: AutoSizeText('You succeed $_questionNumber questions!', style: const TextStyle(color: Color(0xFF101010), fontWeight: FontWeight.bold, fontSize: 20),),
          content: AutoSizeText('Press the button GoOn to go to the level $level\n'
              'Otherwise press the button Exit\n',
                style: const TextStyle(color: Color(0xFF101010), fontWeight: FontWeight.bold, fontSize: 20,)),
          backgroundColor: Colors.lightGreenAccent,
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFF101010),
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const AutoSizeText('Go On',style: TextStyle(color: Colors.white),),
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
              child: const AutoSizeText('Exit',style: TextStyle(color: Colors.white),),
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


