import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_view/quiz_view.dart';
import 'package:spotify/spotify.dart' as sp;

import '../models/answer.dart';
import '../models/question.dart';


class QuizGenerator extends StatelessWidget {
  final List topic;
  final String type_quiz;
  QuizGenerator(this.topic,this.type_quiz);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF101010),
        title: Text("New Quiz",style: new TextStyle(color: Colors.lightGreen,fontSize: 35),),
      ),
      body: QuizGeneratorStateful(topic,type_quiz),

    );
  }
}

class QuizGeneratorStateful extends StatefulWidget {
  final List topic;
  final String type_quiz;

  QuizGeneratorStateful(this.topic, this.type_quiz);
  @override
  _QuizGeneratorState createState() => _QuizGeneratorState(topic,type_quiz);
}


class _QuizGeneratorState extends State<QuizGeneratorStateful> {
  final List topic;
  final String type_quiz;
  List _questions_from_JSON = [];
  late List <Question> _questions = [];
  late PageController _controller;
  late int _question_tot;
  bool end = false;
  int _score = 0;
  int _question_number = 1;
  bool _can_show_button = true;
  late Future<bool> _done;

  _QuizGeneratorState(this.topic,this.type_quiz);

  // Fetch content from the json file
  Future<void> readJson() async {
    print(type_quiz);

    final String response = await rootBundle.loadString(
        'json/question_' + this.type_quiz + '.json');
    final data = await json.decode(response);
    setState(() {
      _questions_from_JSON = data["questions"];
      _can_show_button = false;
      _question_tot = topic.length;
      // if (type_quiz == 'playlists')
      //     buildQuestionPlaylist();
    }
    );

  }

  Future<bool> buildQuestionPlaylist() async{
    await readJson();
    List possible_artists = [];
    List possible_albums = [];
    List possible_tracks = [];
    List<Question> possible_questions = [];
    String answer = "";
    final Question question = Question();
    int i = 0;
    int j = 0;
    for (i = 0; i < topic.length; i++) {
      possible_tracks.add(topic[i].name);
      sp.Artist artist = topic[i].artists[0];
      possible_artists.add(artist.name);
      possible_albums.add(topic[i].album);
    }
    for (i = 0; i < topic.length; i++) {
      if (j > 1)
        j = 0;
      question.question1 = _questions_from_JSON[0]["question1"];
      if (j != 2) {
        question.artist_album = topic[i].name;
        question.question2 = _questions_from_JSON[0]["question2"];
        if (j == 0) {
          sp.Artist artist = topic[i].artists[0];
          answer = artist.name.toString();
          question.right_answer = answer;
          possible_artists.shuffle();
          possible_artists.where((element) =>
          !possible_artists.contains(element[topic[i].artists[0].name])).take(
              3);
          for (int k = 0; k < 3; k++) {
            answer = possible_artists[k].toString();
            question.wrong_answer.add(answer);
          }
        }
      }
      else {
        //TODO playable
      }
      //j++;
      possible_questions.add(question);

      //print(possible_questions[0].artist_album)
    }
    setState(() {
      _questions = possible_questions;
    });

    return true;
  }
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage:0);
    _done = buildQuestionPlaylist();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightGreen,
        padding: const EdgeInsets.all(25),
        child: Column(
            children: [
              // !_can_show_button
              //     ? const SizedBox.shrink(
              // ):
              // ElevatedButton(
              //   onPressed:()=>{}, //readJson,
              //   style: new ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Color(0xFF101010))),
              //   child: const Text('Start Quiz'),
              //
              // ),
              FutureBuilder (
                future: _done,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                  return Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Question $_question_number/${_question_tot}", style: TextStyle(color: Color(0xFF101010), fontSize: 20, fontWeight: FontWeight.bold),),
                          const Divider(thickness:1, color: Colors.grey),
                          Expanded(child: PageView.builder(
                              itemCount: _question_tot,
                              controller: _controller,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                // for (int i = 0; i < 50; i++){
                                //   print(_questions[i].artist_album);
                                // }
                                return QuizView(
                                  image: Container(
                                  width: 150,
                                  height: 150,
                                  child: Image.network(
                                    "https://yt3.ggpht.com/a/AATXAJyPMywRmD62sfK-1CXjwF0YkvrvnmaaHzs4uw=s900-c-k-c0xffffffff-no-rj-mo"),
                                  ),
                                  showCorrect: true,
                                  //tagBackgroundColor: Colors.lightGreen,
                                  //tagColor: Color(0xFF101010),
                                  //questionTag:"Question: "+ (index+1).toString(),
                                  answerColor: Colors.white,
                                  answerBackgroundColor: Color(0xFF101010),
                                  questionColor: Color(0xFF101010),
                                  backgroundColor: Colors.lightGreen,
                                  width: 600,
                                  height: 700,
                                  question: _questions[index].question1 + _questions[index].artist_album + _questions[index].question2,
                                  rightAnswer: _questions[index].right_answer,
                                  wrongAnswers: [_questions[index].wrong_answer[0], _questions[index].wrong_answer[1], _questions[index].wrong_answer[2]],
                                  onRightAnswer: () => {
                                      buildElevatedButton(),
                                      setState(() {
                                        _score++;
                                      })
                                  },
                                  onWrongAnswer: () => {
                                    setState(() {
                                      end = true;
                                      Timer(
                                        Duration(milliseconds: 500),
                                          (){
                                            Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                builder: (context) => ResultPage(score: _score,total: _question_tot,end: end,),
                                              ),);


                                          }
                                      );
                                      })
                                  },
                              );
                            },
    )
                          )])
              );
    }  else return Container();}
                  )
            ]
        ),
    );
  }

  void buildElevatedButton() {
    _controller.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInExpo,
    );
    if (_question_number < _question_tot) {
      setState(() {
        _question_number++;
      });
    }
    else {
      Navigator.pushReplacement(context,
        MaterialPageRoute(
          builder: (context) => ResultPage(score: _score,total: _question_tot,end: end,),
        ),);
    }
  }
}
class ResultPage extends StatelessWidget{
  final int score;
  final int total;
  final bool end;
  const ResultPage({Key?key, required this.score, required this.total, required this.end}): super (key:key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen,
      body:Center(
          child: Column(
            children: [
              SizedBox(height: 300,),
              if (end)
                Text("You missed a question!"),
              Text('You got $score/$total',style: new TextStyle(color: Color(0xFF101010),fontSize: 30,fontWeight: FontWeight.bold),),
              Divider(height: 20,),
              ElevatedButton(style: new ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Color(0xFF101010))),
                onPressed: () => {
                  updateScore(score),
                  Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile()))},
                  child: Text("Exit",style: new TextStyle(color: Colors.white),),),
            ],

          ),

        )
    );
  }
}

Future<void> updateScore(int score) async {
  var user = FirebaseAuth.instance.currentUser;
  var data;
  var bestScore;
  final docRef = FirebaseFirestore.instance.collection("users").doc(user?.email);
  docRef.get().then((DocumentSnapshot doc) {
    data = doc.data() as Map<String, dynamic>;
    bestScore = data["bestScore"];
    print(bestScore);
    if (bestScore < score) {
      docRef.update({
        "bestScore": score,
      });
    }
  },
    onError: (e) => print("Error getting document: $e")

  );

}


