import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/home/home_screen.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/authentication/authentication.dart';
import 'package:dima_project/services/spotify_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spotify/spotify.dart' as spotify_dart;
import 'firebase_options.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key});
  var currUser = null;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<bool> _done;
  SpotifyService _spotifyService = SpotifyService();

  Future<bool> _checkLogin() async{
    print("First line of check login");
    await _checkFirebaseAuth();
    print("Ready to wait for Spotify");
    await _initSpotify();
    print("Finished waiting Spotify");

    return true;
  }

  Future<void> _checkFirebaseAuth() async{
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user != null) {
        print("user: ${user.email}");
        widget.currUser = user;
      }
      else{
        print("No user authenticated");
      }
    });
  }

  Future<void> _initSpotify() async{
    print("First line of init Spotify");
    print("Current user: ${widget.currUser.email}");
    spotify_dart.SpotifyApiCredentials spotifyCredentials = await _spotifyService.getCredentials(widget.currUser);
    print("Got the credentials");
    _spotifyService.spotify = spotify_dart.SpotifyApi(spotifyCredentials);
    print("Created API");
    _spotifyService.saveCredentials();
    print("Saved credentials");
  }

  @override
  void initState() {
    _done = _checkLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF101010),
        body: FutureBuilder(
          future: _done,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            Widget child;
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done){
              if (widget.currUser == null){
                child = AuthenticationScreen();
              }
              else{
                if (_spotifyService.spotify!=null){
                  print("Spotify ok");
                }
                else{
                  print("HERE THE PROBLEM");
                }
                child = HomeScreen();
              }
              return child;
            }
            else {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              );
            }
          },
        )
    );
  }
}
