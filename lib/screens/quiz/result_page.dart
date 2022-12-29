
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/settings/acquire_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


import '../../models/quiz.dart';
import '../profile/userprofile_screen.dart';

class ResultPage extends StatefulWidget {

  const ResultPage( { super.key, required this.score, required this.end});
  final int score;
  final bool end;

  @override
  State<StatefulWidget> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  Quiz quiz = Quiz();
  String? image;

  @override
  void initState() {
    quiz.score = int.parse(widget.score.toString());
  }
  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    final _height = _screenHeight - _statusBarHeight;
    final radius = min(_height * 0.5 * 0.25, _screenWidth * 0.25);


    return Scaffold(
        backgroundColor: Colors.lightGreen,
        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: _height * 0.4,
              ),
              if (widget.end) AutoSizeText("You missed a question!"),
              AutoSizeText(
                'You got ${(widget.score).toString()}',
                style: const TextStyle(
                    color: Color(0xFF101010),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: _height * 0.02,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                            (states) => const Color(0xFF101010))),
                onPressed: () => {
                  updateScore(widget.score),
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserProfile()))
                },
                child: const AutoSizeText(
                  "Exit",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  image = (await AcquireImage().getImageFromCamera())!;
                  if (image != null) {
                    setState(() {
                      quiz.image = image!;
                    });
                  }
                },
                child:
                FutureBuilder<String?>(
                    future: quiz.getImageQuiz(),
                    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                      if (image != null) {
                        File file = File(image!);
                        return CircleAvatar(
                          backgroundColor: const Color(0xFF101010),
                          minRadius: radius,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: radius - 10 > 0 ? radius - 10 : 5.0,
                            backgroundImage: Image.file(file).image,
                          ),
                        );
                      }

                      return
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon( Icons.photo_camera,
                                color: Colors.black,
                                size: 30,
                              ),

                            ],
                          );
                    }
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
Future<XFile?> pickImage() async {
  XFile? imagePicked = await ImagePicker().pickImage(source: ImageSource.camera);
  print(imagePicked!.path);
}

Future<bool> initDoneFalse() async{
  return false;
}
Future<bool> initDoneTrue() async{
  return true;
}
