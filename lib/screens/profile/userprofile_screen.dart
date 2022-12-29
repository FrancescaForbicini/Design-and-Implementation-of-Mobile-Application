import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/home/home_screen.dart';
import 'package:dima_project/screens/quiz/quiz_screen.dart';
import 'package:dima_project/services/authentication_service.dart';
import 'package:dima_project/screens/quiz/quiz_generator.dart';
import 'package:dima_project/services/spotify_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/quiz.dart';
import '../authentication/authentication.dart';

class UserProfile extends StatefulWidget{
  UserProfile({super.key});

  @override
  State<StatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final AuthenticationService _authenticationService = AuthenticationService();
  final SpotifyService _spotifyService = SpotifyService();
  var _user;
  var _username;
  var _email;
  var _photo;
  var _bestScore;
  late Future<bool> _done;

  @override
  void initState() {
    _done = _getUserData();
  }

  Future<bool> _getUserData() async{
    _user = FirebaseAuth.instance.currentUser;
    _email = _user.email;

    var _spotiUser = await _spotifyService.spotify.me.get();
    var _photoRef = _spotiUser.images;
    _username = _spotiUser.displayName;
    if (!_photoRef.isEmpty){
      _photo = Image.network(_photoRef[0].url).image;
    }
    else{
      _photo = Image.asset('images/wolf_user.png').image;
    }
    _bestScore = await getBestScore();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      backgroundColor: Color (0xFF101010),
      leading: IconButton(
        icon: Icon(Icons.logout, color: Colors.lightGreen,size: 30),
        onPressed: () => {
          _authenticationService.signOut(),
          Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticationScreen()))
        },
      ),
      actions: [
        IconButton(icon: Icon(Icons.home, color: Colors.lightGreen,size: 30),
            onPressed:(){ Navigator.push(context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen()));
            }),
      ],
      title: const AutoSizeText(
        'User Profile',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
      ),
    );
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _appBarHeight = _appBar.preferredSize.height;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    final _height = _screenHeight - _appBarHeight - _statusBarHeight;
    final radius = min(_height * 0.5 * 0.25, _screenWidth * 0.25);

    return Scaffold(
      backgroundColor: Color(0xFF101010),
      appBar: _appBar,

      body: FutureBuilder(
          future: _done,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            Widget child;
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done){
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
                        )
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Color(0xFF101010),
                          minRadius: radius,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: radius - 10 > 0 ? radius - 10 : 5.0,
                            backgroundImage: _photo,
                          ),
                        ),
                        AutoSizeText(
                          _username,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF101010),
                          ),
                        ),
                        AutoSizeText(
                          "Best Score: $_bestScore",
                          style: const TextStyle(
                            fontSize: 18,
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
                          title: const AutoSizeText(
                            'E-mail',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: AutoSizeText(
                            _email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.lightGreen,
                            ),
                          ),
                        ),

                        const ListTile(
                          title: AutoSizeText(
                            'My Playlists',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Icon(Icons.queue_music_outlined, color: Colors.lightGreen),
                        ),
                      ],
                    ),
                  )
                ],
              );
              return child;
            }
            else{
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              );
            }
          }
      )

    );
  }

}

Future<int> getBestScore() async{
  var _user = FirebaseAuth.instance.currentUser;
  var _data;
  var _bestScore;
  final docRef = FirebaseFirestore.instance.collection("users").doc(_user?.email);
  await docRef.get().then((DocumentSnapshot doc) {
    _data = doc.data() as Map<String, dynamic>;
    _bestScore = _data["bestScore"];
  });
  if (_bestScore == null)
    return 0;
  return _bestScore;
}
