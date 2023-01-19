import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../generated/l10n.dart';
import '../../models/player.dart';

class GlobalRank extends StatefulWidget{
  final Player currentUser;
  final height;
  final width;
  GlobalRank({required this.currentUser, required this.height, required this.width, super.key});

  @override
  State<StatefulWidget> createState() => _GlobalRankState();
}

class _GlobalRankState extends State<GlobalRank>{

  List bestPlayersUsername = [];
  List bestPlayerPoints = [];
  List bestPlayerLocation = [];
  late Future<bool> done;

  @override
  void initState() {
    done = retrieveBestPLayers();
    super.initState();
  }

  Future<bool> retrieveBestPLayers() async{
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance.collection("quiz").orderBy("score",descending: true).get();
    List<DocumentSnapshot> items = snap.docs.toList(); // List of Documents
    for (int i = 0; i < items.length; i++ ){
      DocumentSnapshot item = items[i];
      bestPlayersUsername.add(item["username"]);
      bestPlayerPoints.add(item["score"].toString());
      bestPlayerLocation.add(item["country"].toString());
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {

    const TextStyle textStyle = TextStyle(
      color: Colors.green,
      fontSize: 20,
      fontWeight: FontWeight.bold,
      wordSpacing: 10
    );

    return FutureBuilder(
      future: done,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
          if (bestPlayersUsername.isEmpty) {
            //print("NO USERS");
            return Center(
                child: AutoSizeText(
                  S.of(context).GlobalErr,
                  style: textStyle,
                )
            );
          }

          //print("THERE ARE USERS");

          return Container(
            height: widget.height,
            width: widget.width,
            child: ListView.builder(
              itemCount: bestPlayersUsername.length,
              itemBuilder: (BuildContext ctx, int idx) => buildLeaderboard(ctx, idx, widget.height, widget.width),
            )
          );
        }
        else{
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightGreen,
            ),
          );
        }
      },
    );
  }

  Widget buildLeaderboard(BuildContext ctx, int idx, var height, var width){
    int pos = idx + 1;
    Widget crown;

    if(pos == 1){
      crown = Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(child: Icon(FontAwesomeIcons.crown, size: 36.0, color: Colors.yellow,),),
            Padding(
              padding: const EdgeInsets.only(left: 6.0, top: 6),
              child: Center(child: AutoSizeText('1', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),),
            )
          ],
        ),
      );
    }
    else if(pos == 2){
      crown = Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(child: Icon(FontAwesomeIcons.crown, size: 36.0, color: Colors.grey[300],),),
            Padding(
              padding: const EdgeInsets.only(left: 6.0, top: 6),
              child: Center(child: AutoSizeText('2', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),),
            )
          ],
        ),
      );
    }
    else if(pos == 3){
      crown = Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(child: Icon(FontAwesomeIcons.crown, size: 36.0, color: Colors.orange[300],),),
            Padding(
              padding: const EdgeInsets.only(left: 6.0, top: 6),
              child: Center(child: AutoSizeText('3', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),),
            )
          ],
        ),
      );
    }
    else{
      crown = CircleAvatar(
        backgroundColor: Colors.grey,
        radius: 13,
        child: AutoSizeText(
          pos.toString(),
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 16
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 10.0),
      child: Container(
        height: height > width ? height * 0.1 : width * 0.1,
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5.0)]
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0.0),
                  child: Row(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 25),
                          child: crown,
                        ),
                      ),

                      Align(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 5),
                              child: Flag.fromString(
                                bestPlayerLocation[idx].toString().toUpperCase(),
                                height: height * 0.03,
                                width: height * 0.03 * 4/3,
                              )
                            )
                          ],
                        ),
                      ),

                      Align(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, top: 5),
                              child: AutoSizeText(
                                bestPlayersUsername[idx],
                                style: const TextStyle(
                                  color: Color(0xFF101010),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AutoSizeText(
                  bestPlayerPoints[idx],
                  style: const TextStyle(
                    color: Color(0xFF101010),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}


