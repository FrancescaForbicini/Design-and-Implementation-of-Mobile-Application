import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/answer.dart';
import '../../models/quiz.dart';
import '../../services/quiz_generator.dart';

class QuizScreen extends StatelessWidget{
  var bestScore = getBestScore();
  QuizScreen();
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
            ]
          ),
          body:Center(
            child: Column(
              children: [
                SizedBox(height: 300,),
                Text('Your best score is ',style: new TextStyle(color: Colors.lightGreen,fontSize: 30,fontWeight: FontWeight.bold),),
                Divider(height: 20,),
                Text('$bestScore ',style: new TextStyle(color: Colors.lightGreen,fontSize: 40,fontWeight: FontWeight.bold),),

              ],

            ),

          )
      ),
    );
  }
}
int getBestScore(){
  var _user = FirebaseAuth.instance.currentUser;
  var data;
  var bestScore;
  final docRef = FirebaseFirestore.instance.collection("users").doc(_user?.email);
  docRef.get().then((DocumentSnapshot doc) {
    data = doc.data() as Map<String, dynamic>;
    bestScore = data["bestScore"];
  });
  if (bestScore == null)
    return 0;
  return bestScore;
}