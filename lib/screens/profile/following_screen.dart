import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/authentication/sign_in/signin.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../models/user.dart';

class FollowingScreen extends StatelessWidget{
  List<User> userfollow = [];

  FollowingScreen({required this.userfollow});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Followings',
        home: Scaffold(
          backgroundColor: Color(0xFF101010),
          appBar: AppBar(
            backgroundColor: Color (0xFF101010),
            leading: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.lightGreen,size: 30,),
                  onPressed:(){ Navigator.push(context,
                    MaterialPageRoute(
                        builder: (context) => UserProfile()));
                 }),
            title: Text('Followings', textAlign: TextAlign.center,style: TextStyle(fontSize: 30),),
          ),
          body: ListView.builder(
            itemCount: userfollow.length,
            itemBuilder: (context, index) {
              return ListTile(
                textColor: Colors.lightGreen,
                title: Text(userfollow[index].username,style: TextStyle(fontSize: 30))
              );
            },
          )
        ),
    );
  }
}