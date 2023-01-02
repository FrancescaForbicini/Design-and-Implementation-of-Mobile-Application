import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import '../../models/player.dart';

class GlobalRank extends StatefulWidget{
  final Player currentUser;
  GlobalRank({required this.currentUser, super.key});

  @override
  State<StatefulWidget> createState() => _GlobalRankState();
}

class _GlobalRankState extends State<GlobalRank>{

  List bestPlayersUsername = [];
  List bestPlayerPoints = [];
  late Future<bool> done;

  @override
  void initState() {
    super.initState();
    done = retrieveBestPLayers();
  }

  Future<bool> retrieveBestPLayers() async{
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance.collection("quiz").orderBy("score",descending: true).get() ;
    List<DocumentSnapshot> items = snap.docs.toList(); // List of Documents
    for (int i = 0; i < items.length; i++ ){
      DocumentSnapshot item = items[i];
      bestPlayersUsername.add(item["username"]);
      bestPlayerPoints.add(item["score"].toString());
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
      backgroundColor: Color(0xFF101010),
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.lightGreen, size: 30),
        onPressed: () =>
        {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserProfile()))
        },
      ),
      title: const AutoSizeText(
        'Global Rank',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
      ),
    );
    final _screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final _screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final _appBarHeight = _appBar.preferredSize.height;
    final _statusBarHeight = MediaQuery
        .of(context)
        .padding
        .top;
    final _height = _screenHeight - _appBarHeight - _statusBarHeight;
    final radius = min(_height * 0.5 * 0.25, _screenWidth * 0.25);
    final TextStyle textStyle = TextStyle(
    color: Colors.green,
    fontSize: 20,
    fontWeight: FontWeight.bold,wordSpacing: 10);

    return Scaffold(
        backgroundColor: Color(0xFF101010),
        appBar: _appBar,

        body: ListView(
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
                        backgroundImage: widget.currentUser.image,
                      ),

                    ),
                    AutoSizeText(
                      widget.currentUser.username,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF101010),
                      ),
                    ),
                    AutoSizeText(
                      "Best Score " + widget.currentUser.bestScore,
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
                  width: _screenWidth,
                  child: Row(
                      children: <Widget>[
                        AutoSizeText(
                          'Position ', style: textStyle,),
                        AutoSizeText(
                          "Location ", style: textStyle,),
                        AutoSizeText(
                          'Username ' , style: textStyle,),
                        AutoSizeText(
                          'Score', style: textStyle,),
                        SizedBox(
                          height: 30,
                        )

                      ]
                  ),
              ),
              FutureBuilder(
                  future: done,
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      if (bestPlayersUsername.isEmpty) {
                        return Center(
                          child: AutoSizeText("There Are No Players", style: textStyle,)
                        );
                      }
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: bestPlayersUsername.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: _screenWidth,
                              child: Row(
                                  children: <Widget>[
                                    AutoSizeText('${index+1}°  ', style: textStyle,),
                                    AutoSizeText(
                                      "Italy ", style: textStyle,),
                                    AutoSizeText(
                                      bestPlayersUsername[index] +' ' , style: textStyle,),
                                    AutoSizeText(
                                      bestPlayerPoints[index], style: textStyle,),
                                    const SizedBox(
                                      height: 30,
                                    )
                                  ]
                              ),
                            );
                          }
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }
              )
            ]
        )
    );
  }



}


