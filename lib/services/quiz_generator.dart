import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/services/spotify_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quiz_view/quiz_view.dart';
import 'package:spotify/spotify.dart' as sp;

import '../models/question.dart';

class QuizGenerator extends StatelessWidget {
  final topic;
  final String type_quiz;

  QuizGenerator(this.topic, this.type_quiz);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF101010),
        title: Text(
          "New Quiz",
          style: new TextStyle(color: Colors.lightGreen, fontSize: 35),
        ),
      ),
      body: QuizGeneratorStateful(topic, type_quiz),
    );
  }
}

class QuizGeneratorStateful extends StatefulWidget {
  final topic;
  final String type_quiz;

  QuizGeneratorStateful(this.topic, this.type_quiz);

  @override
  _QuizGeneratorState createState() => _QuizGeneratorState(topic, type_quiz);
}

class _QuizGeneratorState extends State<QuizGeneratorStateful> {
  final topic;
  final String type_quiz;
  AudioPlayer audioPlayer = AudioPlayer();
  List<Question> _questions = [];
  late PageController _controller;
  List _questions_from_JSON = [];
  bool end = false;
  int _score = 0;
  int _question_number = 1;
  late Future<bool> _done;

  _QuizGeneratorState(this.topic, this.type_quiz);

  // Fetch content from the json file
  Future<bool> readJson() async {
    final String response = await rootBundle
        .loadString('json/question_' + this.type_quiz + '.json');
    final data = await json.decode(response);
    setState(() {
      _questions_from_JSON = data["questions"];
    });
    switch (type_quiz) {
      case 'playlists':
        {
          await buildQuestionPlaylist();
          break;
        }

      case 'artists':
        {
          await buildQuestionArtists();
          break;
        }
      default:
        {
          print("error");
          break;
        }
    }

    return true;
  }

  Future<void> buildQuestionArtists() async {
    List<sp.AlbumSimple?> allAlbums = [];
    List<sp.TrackSimple> allTracks = [];
    List<String?> allYearsAlbum = [];
    int i = 0;
    int _typeQuestion = 0;
    sp.Artist artist = topic;
    sp.Artists artistsRetrieve = sp.Artists(SpotifyService().spotify);
    var id = artist.id;
    List<String> input = ["album"];
    sp.Pages<sp.Album> _albumsPages = artistsRetrieve.albums(id!,includeGroups: input);
    Iterable<sp.Album> _albumsLists = await _albumsPages.all();
    allAlbums = _albumsLists.toList();
    late List<List<sp.TrackSimple>> allTracksForAlbum = new List.generate(allAlbums.length, (i) => []);

    allAlbums.shuffle();
    for (i = 0; i < allAlbums.length; i++) {
      String? _id = allAlbums[i]?.id.toString();
      allTracksForAlbum[i].addAll(await sp.Albums(SpotifyService().spotify)
          .getTracks(_id.toString())
          .all());
      allTracks.addAll(allTracksForAlbum[i]);
    }
    allYearsAlbum =
        allAlbums.map((e) => e?.releaseDate?.substring(0, 4).toString()).toList();

    for (i = 0; i < allAlbums.length; i++) {
      Question question = new Question();
      String? answer = "";
      List<String?> _wrongAnswers = List.empty(growable: true);

      if (_typeQuestion > 3) {
        _typeQuestion = 0;
      }

      question.question1 = _questions_from_JSON[_typeQuestion]["question1"];
      question.question2 = _questions_from_JSON[_typeQuestion]["question2"];

      switch (_typeQuestion) {
        case 0:
          {
            question.artistAlbum = allAlbums[i]?.name;
            answer = allAlbums[i]?.releaseDate?.substring(0, 4).toString();
            question.rightAnswer = answer;
            allYearsAlbum.shuffle();
            _wrongAnswers =
                allYearsAlbum.where((element) => element != answer).take(3).toList();
            for (int k = 0; k < 3; k++) {
              question.wrongAnswers.add(_wrongAnswers[k]!);
            }
            break;
          }
        case 1:
        {
          question.artistAlbum = allAlbums[i]?.name;
          List<sp.TrackSimple> rightAnswersTracks = allTracksForAlbum[i];
          allTracks.shuffle();
          List<sp.TrackSimple> wrongAnswersTracks = allTracks.where((element) => !rightAnswersTracks.contains(element)).take(3).toList();
          int randomTrack = Random().nextInt(rightAnswersTracks.length);
          answer = rightAnswersTracks[randomTrack].name;

          question.rightAnswer = answer;
          for (int k = 0; k < 3; k++) {
            question.wrongAnswers.add(wrongAnswersTracks[k].name!);
          }
          break;

        }

        case 2:
          {
            question.artistAlbum = allAlbums[i]?.name;
            allTracksForAlbum[i].shuffle();
            List<sp.TrackSimple> wrongAnswerTracks = allTracksForAlbum[i];
            allTracks.shuffle();
            List<sp.TrackSimple> rightAnswerTracks = allTracks.where((element) => !wrongAnswerTracks.contains(element)).toList();
            int randomTrack = Random().nextInt(rightAnswerTracks.length);
            answer = rightAnswerTracks[randomTrack].name;
            question.rightAnswer = answer;
            wrongAnswerTracks.shuffle();
            for (int k = 0; k < 3; k++) {
              question.wrongAnswers.add(wrongAnswerTracks[k].name!);
            }
            break;
          }
        case 3:
        {
          int randomTrack = Random().nextInt(allTracksForAlbum[i].length);
          sp.TrackSimple trackSelected = allTracksForAlbum[i][randomTrack];
          question.url = trackSelected.previewUrl.toString();
          answer = trackSelected.name.toString();
          question.rightAnswer = trackSelected.name;
          allTracksForAlbum[i].shuffle();
          List<sp.TrackSimple> wrongAnswerTracks = allTracksForAlbum[i]
              .where((element) => element.name != trackSelected.name)
              .take(3)
              .toList();
          question.isPresent = true;
          for (int k=0; k < 3; k++) {
            question.wrongAnswers.add(wrongAnswerTracks[k].name!);
          }
          break;
        }
      }
      _questions.add(question);
      _typeQuestion++;
    }
    _questions.shuffle();
  }

  Future<void> buildQuestionPlaylist() async{
    List<String> allArtists = List.empty(growable: true);
    List<String> allAlbums = List.empty(growable: true);
    List<String> allTracks = List.empty(growable: true);
    int i = 0;
    int _typeQuestion = 0;
    topic.shuffle();
    for (i = 0; i < topic.length; i++) {
      sp.Track track = topic[i];
      if (!allArtists.contains(track.name.toString())) {
        allTracks.add(track.name.toString());
      }
      sp.Artist artist = topic[i].artists[0];
      if (!allArtists.contains(artist.name.toString())) {
        allArtists.add(artist.name.toString());
      }
      sp.AlbumSimple album = topic[i].album;
      if (!allAlbums.contains(album.name.toString())) {
        allAlbums.add(album.name.toString());
      }
    }
    for (i = 0; i < topic.length; i++) {
      Question question = new Question();
      String answer = "";

      if (_typeQuestion > 2)
        _typeQuestion = 0;

      question.question1 = _questions_from_JSON[_typeQuestion]["question1"];
      question.question2 = _questions_from_JSON[_typeQuestion]["question2"];

      List<String> wrongAnswers = [];

      switch (_typeQuestion) {
        case 0:
          {
            question.artistAlbum = topic[i].name;
            sp.Artist artist = topic[i].artists[0];
            answer = artist.name.toString();
            question.rightAnswer = answer;
            allArtists.shuffle();
            wrongAnswers = allArtists
                .where((element) => element != topic[i].artists[0].name)
                .take(3)
                .toList();

            break;
          }

        case 1:
          {
            question.artistAlbum = topic[i].name;
            sp.AlbumSimple album = topic[i].album;
            answer = album.name.toString();
            question.rightAnswer = answer;
            allAlbums.shuffle();
            wrongAnswers = allAlbums
                .where((element) => element != album.name)
                .take(3)
                .toList();

            break;
          }

        case 2:
          {
            sp.Track track = topic[i];
            question.url = track.previewUrl.toString();
            answer = track.name.toString();
            question.rightAnswer = answer;
            allTracks.shuffle();
            wrongAnswers = allTracks
                .where((element) => element != topic[i].name)
                .take(3)
                .toList();
            question.isPresent = true;
            break;
          }
      }
      for (int k = 0; k < 3; k++) {
        answer = wrongAnswers[k].toString();
        question.wrongAnswers.add(answer);
      }

      _questions.add(question);
      _typeQuestion++;
    }
    _questions.shuffle();
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
      color: Colors.lightGreen,
      padding: const EdgeInsets.all(25),
      child: Column(children: [
        FutureBuilder(
            future: _done,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return Expanded(
                    child: Column(

                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                      Text(
                        "Question $_question_number",
                        style: const TextStyle(
                            color: Color(0xFF101010),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const Divider(thickness: 1, color: Colors.grey),
                      Expanded(
                          child: PageView.builder(
                        itemCount: _questions.length + _question_number,
                        controller: _controller,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          double h, w;
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
                            answerBackgroundColor: Color(0xFF101010),
                            questionColor: Color(0xFF101010),
                            backgroundColor: Colors.lightGreen,
                            width: 600,
                            height: 700,
                            question: _questions[index].question1 +
                                _questions[index].artistAlbum.toString() +
                                _questions[index].question2,
                            rightAnswer: _questions[index].rightAnswer,
                            wrongAnswers: [
                              _questions[index].wrongAnswers[0],
                              _questions[index].wrongAnswers[1],
                              _questions[index].wrongAnswers[2]
                            ],
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
                                Timer(Duration(milliseconds: 500), () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ResultPage(
                                        score: _score,
                                        end: end,
                                      ),
                                    ),
                                  );
                                });
                              })
                            },
                          );
                        },
                      ))
                    ]));
              } else {
                return Container(
                );
              }
            })
      ]),
    );
  }

  void buildElevatedButton() async{
    _controller.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInExpo,
    );
    if (_question_number < _questions.length) {
      setState(() {
        _question_number++;
      });
    } else {
      _question_number ++;
      if (type_quiz == 'playlist')
        buildQuestionPlaylist();
      else
        buildQuestionArtists();
    }
  }
}

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
              SizedBox(
                height: 300,
              ),
              if (end) Text("You missed a question!"),
              Text(
                'You got $score',
                style: new TextStyle(
                    color: Color(0xFF101010),
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Divider(
                height: 20,
              ),
              ElevatedButton(
                style: new ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Color(0xFF101010))),
                onPressed: () => {
                  updateScore(score),
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => UserProfile()))
                },
                child: Text(
                  "Exit",
                  style: new TextStyle(color: Colors.white),
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
