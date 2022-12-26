import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../profile/userprofile_screen.dart';

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