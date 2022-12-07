import 'dart:async';
import 'dart:convert';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_view/quiz_view.dart';

import '../models/answer.dart';
import '../models/question.dart';


class QuizGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF101010),
        title: Text("New Quiz",style: new TextStyle(color: Colors.lightGreen,fontSize: 35),),
      ),
      body: QuizGeneratorStateful(),

    );
  }
}

class QuizGeneratorStateful extends StatefulWidget {
  @override
  _QuizGeneratorState createState() => _QuizGeneratorState();
}


class _QuizGeneratorState extends State<QuizGeneratorStateful> {
  List _questions = [];
  //TODO remove answers when we'll use spotify
  Answer answer = Answer();
  Answer answer2 = Answer();
  late String _name;
  late String _album;
  late PageController _controller;
  late int _question_tot;
  bool end = false;
  int _score = 0;
  int _question_number = 1;
  bool _can_show_button = true;
  // Fetch content from the json file
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('json/question.json');
    final data = await json.decode(response);
    setState(() {
      _questions = data["questions"];
      answer.text = 'ciao';
      answer.correct = false;
      answer2.text = 'addio';
      answer2.correct = true;
      _question_tot = _questions.length;
      _name = "Rocket";
      _album = "ANN";
      _can_show_button = false;
    });

  }


  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage:0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.lightGreen,
        padding: const EdgeInsets.all(25),
        child: Column(

            children: [
              !_can_show_button
                  ? const SizedBox.shrink(
              ):
              ElevatedButton(
                onPressed: readJson,
                style: new ButtonStyle(backgroundColor: MaterialStateColor.resolveWith((states) => Color(0xFF101010))),
                child: const Text('Start Quiz'),

              ),
              _questions.isNotEmpty
                  ? Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("Question $_question_number/${_questions.length}", style: TextStyle(color: Color(0xFF101010), fontSize: 20, fontWeight: FontWeight.bold),),
                          const Divider(thickness:1, color: Colors.grey),
                          Expanded(child: PageView.builder(
                              itemCount: _questions.length,
                              controller: _controller,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final Question question = Question();
                                question.question1 =
                                _questions[index]['question1'].toString();
                                question.name =
                                _name;
                                question.question2 =
                                _questions[index]['question2'].toString();
                                question.artist_album =
                                _album;
                                question.options = [answer,answer2];
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
                                  question: question.question1.toString()+
                                    question.artist_album.toString()+question.question2.toString(),
                                  rightAnswer: answer2.text,
                                  wrongAnswers: [answer.text, "ROCKET"],
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
              ):Container()
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
                onPressed: () => {Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile()))},
                  child: Text("Exit",style: new TextStyle(color: Colors.white),),),
            ],

          ),

        )
    );
  }
}

