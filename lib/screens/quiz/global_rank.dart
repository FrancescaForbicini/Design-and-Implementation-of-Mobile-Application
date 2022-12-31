import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

class MyQuiz extends StatelessWidget{
  final user;
  const MyQuiz(this.user, {super.key});

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
    var photoUser;
    var users;
    var points;
    int i = 0;
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      appBar: _appBar,

      body: Flexible(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Quiz')
                  .where('quiz', isEqualTo: '12')
                  .orderBy('points', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  i = 0;
                  return ListView.builder(
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        if (index >= 1) {
                            points = snapshot.data?.docs[index].get("points").toString();
                            users = snapshot.data?.docs[index].get("user").toString();
                          //TODO how to retrieve things?
                        }
                        i++;
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          child: InkWell(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: i == 0 ? Colors.amber
                                          : i == 1 ? Colors.grey
                                          : i == 2 ? Colors.brown
                                          : Colors.white,
                                      width: 3.0,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(5.0)),
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0, left: 15.0),
                                        child: Row(
                                          children: <Widget>[
                                            CircleAvatar(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        image: DecorationImage(
                                                            image: Image.asset("images/wolf_user.png").image,
                                                            // image: NetworkImage(
                                                            //     snapshot.data?.docs[index].get("ph")),
                                                            fit: BoxFit
                                                                .fill)))),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0, top: 10.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(users.username,
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontWeight: FontWeight
                                                          .w500), maxLines: 6,)
                                            ),
                                            Text("Points: " +
                                                points),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                  );
                } else
                  return CircularProgressIndicator();
              }
          )
      ),
    );
  }

}