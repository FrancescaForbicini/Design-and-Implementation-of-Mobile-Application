import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_view/quiz_view.dart';


class QuizGenerator extends StatelessWidget{
  const QuizGenerator({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NewQuiz',
      home: Scaffold(
          backgroundColor: Color (0xFF101010),
          appBar: AppBar(
            backgroundColor: Color (0xFF101010),
            title: Text('New Quiz', textAlign: TextAlign.center,style: new TextStyle(fontSize: 30, color: Colors.lightGreen),),
          ),
          body:Center(
              child: QuizView(
                image: Container(
                  width: 150,
                  height: 150,
                  child: Image.network(
                      "https://yt3.ggpht.com/a/AATXAJyPMywRmD62sfK-1CXjwF0YkvrvnmaaHzs4uw=s900-c-k-c0xffffffff-no-rj-mo"),
                ),
                showCorrect: true,
                tagBackgroundColor: Colors.lightGreen,
                tagColor: Color (0xFF101010),
                questionTag: "Question: 2",
                answerColor: Colors.white,
                answerBackgroundColor: Color (0xFF101010),
                questionColor: Color (0xFF101010),
                backgroundColor: Colors.lightGreen,
                width: 600,
                height: 700,
                question: "Which is the best framework for app development?",
                rightAnswer: "Flutter",
                wrongAnswers: ["Fluttor", "Flitter"],
                //TODO go to another question.json
                onRightAnswer: () => print("Right") ,
                onWrongAnswer: () => print("Wrong"),
              )
          )
      ),
    );
  }
}