import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quiz_view/quiz_view.dart';
import 'package:spotify/spotify.dart' as sp;

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
  AudioPlayer audioPlayer = AudioPlayer();
  List <String> possible_artists =  List.empty(growable: true);
  List <String> possible_albums =  List.empty(growable: true);
  List <String> possible_tracks =  List.empty(growable: true);
  List _questions_from_JSON = [];
  List <Question> _questions = List.empty(growable:true);
  late PageController _controller;
  String answer = "";
  late int _question_tot;
  bool end = false;
  int _score = 0;
  int _question_number = 1;
  late Future<bool> _done;
  _QuizGeneratorState(this.topic,this.type_quiz);

  // Fetch content from the json file
  Future<bool> readJson() async {
    final String response = await rootBundle.loadString(
        'json/question_' + this.type_quiz + '.json');
    final data = await json.decode(response);
    setState(() {
      _questions_from_JSON = data["questions"];
      _question_tot = topic.length;
    });
    buildQuestionPlaylist();
    return true;
  }

  void buildQuestionPlaylist(){
    int i = 0;
    int type_question = 0;
    for (i = 0; i < topic.length; i++)  {
      sp.Track track = topic[i];
      if (!possible_artists.contains(track.name.toString()))
        possible_tracks.add(track.name.toString());
      sp.Artist artist = topic[i].artists[0];
      if (!possible_artists.contains(artist.name.toString()))
        possible_artists.add(artist.name.toString());
      sp.AlbumSimple album = topic[i].album;
      if (!possible_albums.contains(album.name.toString()))
        possible_albums.add(album.name.toString());
    }
    for (i = 0; i < topic.length; i++) {
      Question question = new Question();

      if (type_question > 2)
        type_question = 0;

      question.question1 = _questions_from_JSON[type_question]["question1"];
      question.question2 = _questions_from_JSON[type_question]["question2"];

      List<String> wrong_answers = List.empty(growable: true);

      switch(type_question){
        case 0:
          {
            question.artist_album = topic[i].name;
            sp.Artist artist = topic[i].artists[0];
            answer = artist.name.toString();
            question.right_answer = answer;
            possible_artists.shuffle();
            wrong_answers = possible_artists.where((element) => element !=
                topic[i].artists[0].name).take(3).toList();

            break;
          }

        case 1:
          {
            question.artist_album = topic[i].name;
            sp.AlbumSimple album = topic[i].album;
            answer = album.name.toString();
            question.right_answer = answer;
            possible_albums.shuffle();
            wrong_answers = possible_albums.where((element) => element !=
                topic[i].album.name).take(3).toList();

            break;
          }

        case 2:{
          sp.AlbumSimple album = topic[i].album;
          sp.Track track = topic[i];
          question.track = track;
          if (album.images!.isEmpty) {
            question.image = Image.network(album.images![0].url!);
          }
          answer = track.name.toString();
          question.right_answer = answer;
          possible_tracks.shuffle();
          wrong_answers = possible_tracks.where((element) => element !=
              topic[i].name).take(3).toList();
          question.isPresent = true;
          break;
        }

      }
      for (int k = 0; k < 3; k++) {
        answer = wrong_answers[k].toString();
        question.wrong_answer.add(answer);
      }

      _questions.add(question);
      type_question ++;
    }
  }
  @override
  void initState() {
    _done = readJson();

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
              FutureBuilder(
                future: _done,
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                  return Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Question $_question_number/$_question_tot", style: TextStyle(color: Color(0xFF101010), fontSize: 20, fontWeight: FontWeight.bold),),
                        const Divider(thickness:1, color: Colors.grey),
                        Expanded(child: PageView.builder(
                          itemCount: _question_tot,
                          controller: _controller,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            double h,w;
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
                                  onTap:() async {
                                    print(_questions[index].track.previewUrl);
                                    // print("ciao"+  _questions[index].track.previewUrl.toString());

                                    await audioPlayer.setUrl(_questions[index].track.previewUrl!);
                                    await audioPlayer.play();
                                  } ,
                                ),
                              ),
                              showCorrect: true,
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
                                audioPlayer.stop(),
                                buildElevatedButton(),
                                setState(() {
                                  _score++;
                                })
                              },
                              onWrongAnswer: () => {
                                  audioPlayer.stop(),
                                  setState(() {
                                    end = true;
                                    Timer(Duration(milliseconds: 500),
                                    (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ResultPage(score: _score,total: _question_tot,end: end,),),);});
                                  })
                              },
                            );
                            },
                        )
                        )])
                  );
                }else return Container();
                }
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
void playSong(Question question) async{

}
Future<void> updateScore(int score) async {
  var user = FirebaseAuth.instance.currentUser;
  var data;
  var bestScore;
  final docRef = FirebaseFirestore.instance.collection("users").doc(user?.email);
  docRef.get().then((DocumentSnapshot doc) {
    data = doc.data() as Map<String, dynamic>;
    bestScore = data["bestScore"];
    if (bestScore < score) {
      docRef.update({
        "bestScore": score,
      });
    }
  },
    onError: (e) => print("Error getting document: $e")

  );

}


