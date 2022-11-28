import 'dart:convert';

import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quiz_view/quiz_view.dart';

import '../models/question.dart';

class QuizGenerator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewQuiz',
      home: QuizGeneratorStateful()
    );
  }
}

class QuizGeneratorStateful extends StatefulWidget {

  @override
  _QuizGeneratorState createState() => _QuizGeneratorState();
}


class _QuizGeneratorState extends State<QuizGeneratorStateful> {
  final List<Question> _questions = <Question>[];
  final Question _question = Question();
  final _name = "Rocket";
  final _album = "ANN";
  Future<void> readJson() async {
    final String response = await rootBundle.loadString('json/question.json');
    final data = await json.decode(response);
    setState(() {
      int i = 0;
      while (i!=5) {
        //TODO check the topic and put the right name,album and artist with spotify
        _question.topic = data[i]['topic'].toString();
        _question.name = _name.toString();
        _question.question1 = data[i]['question1'].toString();
        //TODO depends on the topic
        _question.artist_album = _album.toString();
        _question.question2 = data[i]['question2'].toString();
        _questions.insert(i, _question);
        i++;
      }
    });
  }
  @override
  void initState(){
    readJson();
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
          backgroundColor: Color(0xFF101010),
          appBar: AppBar(
            backgroundColor: Color(0xFF101010),
            title: Text('New Quiz', textAlign: TextAlign.center,
              style: new TextStyle(fontSize: 30, color: Colors.lightGreen),),
          ),
          body: ListView.builder(
            itemCount: _questions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title:
                     QuizView(
                      image: Container(
                      width: 150,
                      height: 150,
                      child: Image.network(
                      "https://yt3.ggpht.com/a/AATXAJyPMywRmD62sfK-1CXjwF0YkvrvnmaaHzs4uw=s900-c-k-c0xffffffff-no-rj-mo"),
                      ),
                      showCorrect: true,
                      tagBackgroundColor: Colors.lightGreen,
                      tagColor: Color(0xFF101010),
                      questionTag:"Question: "+ (index+1).toString(),
                      answerColor: Colors.white,
                      answerBackgroundColor: Color(0xFF101010),
                      questionColor: Color(0xFF101010),
                      backgroundColor: Colors.lightGreen,
                      width: 600,
                      height: 700,
                      question: _questions[index].question1.toString()+
                          _questions[index].name.toString()+_questions[index].question2.toString(),
                      rightAnswer: "Flutter",
                      wrongAnswers: ["Fluttor", "Flitter"],
                      onRightAnswer: () => showDialog(context: context, builder:
                          (context) => AlertDialog(
                            backgroundColor: Colors.lightGreen,
                            title: Text("Answer",style: new TextStyle(
                        color: Color(0xFF101010),fontSize: 20)),
                        content: Text("Correct!",style: new TextStyle(
                          color: Color(0xFF101010),fontSize: 30,
                        ),),
                        actions: [
                          TextButton(
                            child: Text("Next question",style: new TextStyle(color: Color(0xFF101010))),
                            onPressed:() { Navigator.pop(context);})
                        ],),
                      ),
                      onWrongAnswer: () => showDialog(context: context, builder:
                          (context) => AlertDialog(
                        backgroundColor: Colors.redAccent,
                        title: Text("Answer",style: new TextStyle(
                            color: Color(0xFF101010),fontSize: 20)),
                        content: Text("Wrong!",style: new TextStyle(
                          color: Color(0xFF101010),fontSize: 30,
                        ),),
                        actions: [
                          TextButton(
                              child: Text("Next question",style: new TextStyle(color: Color(0xFF101010))),
                              onPressed:() { Navigator.pop(context);})
                        ],),
                      ),
                      )
                  );
                      },
                    ),
              ),
    );
  }

}
