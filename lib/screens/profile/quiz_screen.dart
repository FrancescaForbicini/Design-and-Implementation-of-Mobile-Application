import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/answer.dart';
import '../../models/quiz.dart';
import '../../services/quiz_generator.dart';

class QuizScreen extends StatelessWidget{
  Quiz quiz;
  List <Answer> answers;
  QuizScreen({required this.quiz, required this.answers});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz',
      home: Scaffold(
          backgroundColor: Color(0xFF101010),
          appBar: AppBar(
            title: Text('My Quizzes',style: TextStyle(fontSize: 30, color: Colors.lightGreen), ),

            backgroundColor: Color (0xFF101010),
            actions:<Widget> [
              IconButton( icon: Icon(Icons.arrow_back, color: Colors.lightGreen), onPressed:(){ Navigator.push(context,
                  MaterialPageRoute(
                      builder: (context) => UserProfile()));
              }),
              IconButton(icon: Icon(Icons.add,color: Colors.lightGreen), onPressed:(){ Navigator.push(context,
                 MaterialPageRoute(
                    builder: (context) => const QuizGenerator()));
              }),

            ],

          ),
          body:
          ListView.builder(
            itemCount: quiz.questions.length,
            itemBuilder: (context, index) {
              return ListTile(
                  textColor: Colors.lightGreen,
                  title: Text(quiz.questions[index].text,style: TextStyle(fontSize: 30)),
                  subtitle: ListView.builder(
                      itemCount: answers.length,
                      itemBuilder: (context, index){
                        return ListTile(
                            title: Text(answers[index].text, style: TextStyle(fontSize: 20)),
                        );
                      },
                  ),
              );
            },
          )
      ),
    );
  }
}