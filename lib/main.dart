import 'dart:convert';
import 'dart:io';

import 'package:dima_project/screens/home/home_screen.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _user = null;
  late Future<bool> _done;

  Future<bool> _checkLogin() async{
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user != null) {
        _user = user;
      }
      else{
        print("No user authenticated");
      }
    });

    return true;
  }

  @override
  void initState() {
    _done = _checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: _done,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            Widget child;
            if (snapshot.connectionState == ConnectionState.done ){
              if (_user == null){
                child = AuthenticationScreen();
              }
              else{
                child = HomeScreen();
              }
              return child;
            }
            else {
              return CircularProgressIndicator();
            }
          },
        )
    );
  }
}
