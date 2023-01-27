import 'dart:io';
import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/customized_app_bar.dart';
import 'package:dima_project/screens/home/home_screen.dart';
import 'package:dima_project/screens/quiz/best_quiz_screen.dart';
import 'package:dima_project/services/authentication_service.dart';
import 'package:dima_project/screens/quiz/quiz_generator.dart';
import 'package:dima_project/services/spotify_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../models/player.dart';
import '../../models/quiz.dart';
import '../authentication/authentication.dart';
import '../quiz/global_rank.dart';
import '../quiz/rank.dart';
import '../settings/acquire_image.dart';

class UserProfile extends StatefulWidget {
  UserProfile({super.key});

  @override
  State<StatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthenticationService _authenticationService = AuthenticationService();
  final SpotifyService _spotifyService = SpotifyService();
  late Future<bool> _done;
  Player currentUser = Player();

  @override
  void initState() {
    _done = _getUserData();
  }

  Future<bool> _getUserData() async {
    var _user;
    _user = FirebaseAuth.instance.currentUser;
    final docRef =
        FirebaseFirestore.instance.collection("users").doc(_user?.email);
    var data = await docRef.get();
    var _spotiUser = await _spotifyService.spotify.me.get();
    var _photoRef = _spotiUser.images;
    var _photo = await _authenticationService.getUserImage();

    currentUser.email = _user.email;

    currentUser.username = data['username'];

    if (_photo != null) {
      currentUser.image = Image.file(File(_photo)).image;
    } else if (!_photoRef.isEmpty) {
      currentUser.image = Image.network(_photoRef[0].url).image;
    } else {
      currentUser.image = Image.asset('images/wolf_user.png').image;
    }
    currentUser.bestScore = await getBestScore();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Color iconColor = Theme.of(context).iconTheme.color!;
    Color backgroundColor = Theme.of(context).backgroundColor;
    Color? textColor = Theme.of(context).textTheme.headline1?.color;
    final _appBar = CustomizedAppBar(
      leading: IconButton(
        key: const Key('sign_out_button'),
        icon: const Icon(Icons.logout, color: Colors.lightGreen, size: 30),
        onPressed: () => {
          _authenticationService.signOut(),
          Navigator.pop(context),
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AuthenticationScreen()))
        },
      ),
      actions: [
        IconButton(
            key: const Key('home_button'),
            icon: Icon(Icons.home, size: 30, color: iconColor),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
      ],
      title: AutoSizeText(
        S.of(context).UserTitle,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 30),
      ),
    );

    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _appBarHeight = _appBar.preferredSize.height;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    final _height = _screenHeight - _appBarHeight - _statusBarHeight;
    final radius = min(_height * 0.5 * 0.25, _screenWidth * 0.25);
    late var image;

    return Scaffold(
        key: const Key('userprofile_page'),
        backgroundColor: backgroundColor,
        appBar: _appBar,
        body: FutureBuilder(
            future: _done,
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              Widget child;
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                child = ListView(
                  children: <Widget>[
                    Container(
                      height: _height * 0.5,
                      width: _screenWidth,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                        colors: [Colors.green, Colors.lightGreen],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        stops: [0.5, 0.9],
                      )),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                            fit: StackFit.passthrough,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                minRadius: radius,
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: radius - 10 > 0 ? radius - 10 : 5.0,
                                  backgroundImage: currentUser.image,
                                ),
                              ),
                              Positioned(
                                right: _height > _screenWidth
                                    ? _screenWidth * 0.5 - radius
                                    : _screenWidth * 0.5 - 1.2 * radius,
                                bottom: 0,
                                child: IconButton(
                                  iconSize: radius - 10 > 0
                                      ? (radius - 10) * 0.5
                                      : 2.5,
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Color(0xFF101010),
                                  ),
                                  onPressed: () async {
                                    image = (await AcquireImage()
                                        .getImageFromCamera())!;
                                    if (image != null) {
                                      await _authenticationService
                                          .changeUserImage(image);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          AutoSizeText(
                            currentUser.username,
                            style: TextStyle(
                              fontSize: _screenWidth > _height
                                  ? _screenWidth / 40
                                  : _height / 25,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF101010),
                            ),
                          ),
                          AutoSizeText(
                            S.of(context).UserBestScore(currentUser.bestScore),
                            style: TextStyle(
                              fontSize: _screenWidth > _height
                                  ? _screenWidth / 60
                                  : _height / 40,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF101010),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: _screenHeight * 0.5,
                      width: _screenWidth,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: AutoSizeText(
                              S.of(context).UserEmail,
                              style:  TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: AutoSizeText(
                              currentUser.email,
                              style:  TextStyle(
                                fontSize: 16,
                                color: textColor,
                              ),
                            ),
                          ),
                          ListTile(
                            key: const Key('bestquiz_button'),
                            title: AutoSizeText(
                              S.of(context).UserQuiz,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: Icon(
                              Icons.queue_music_outlined,
                              color: iconColor,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BestQuiz(),
                                ),
                              );
                            },
                          ),
                          ListTile(
                            key: const Key('rank_button'),
                            title: AutoSizeText(
                              S.of(context).UserRank,
                              style:  TextStyle(
                                color: textColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            leading: Icon(
                              Icons.list_alt_outlined,
                              color: iconColor,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Rank(currentUser: currentUser),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                );
                return child;
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.lightGreen,
                  ),
                );
              }
            }));
  }
}

Future<String> getBestScore() async {
  var _user = FirebaseAuth.instance.currentUser;
  var _data;
  var _bestScore;
  final docRef =
      FirebaseFirestore.instance.collection("users").doc(_user?.email);
  await docRef.get().then((DocumentSnapshot doc) {
    _data = doc.data() as Map<String, dynamic>;
    _bestScore = _data["bestScore"];
  });
  if (_bestScore == null) {
    return '0';
  }
  return "$_bestScore";
}
