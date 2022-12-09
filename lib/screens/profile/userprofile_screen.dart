import 'package:dima_project/screens/home/home_screen.dart';
import 'package:dima_project/screens/profile/quiz_screen.dart';
import 'package:dima_project/services/authentication_service.dart';
import 'package:dima_project/services/quiz_generator.dart';
import 'package:flutter/material.dart';

import '../../models/quiz.dart';
import '../../models/user.dart';
import '../authentication/authentication.dart';
import 'follower_screen.dart';
import 'following_screen.dart';

class UserProfile extends StatelessWidget {
  final AuthenticationService _authenticationService = AuthenticationService();
  final List<User> userfollow = [new User(id: '1', name:'raff' , surname:'kik', username:'rocket', email: 'rocket@ann')];
  final User user = new User(id: '1', name: 'francesca', surname: 'forbicini', email: 'francesca.forbicini@gmail.com',username:'frafra');

  UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF101010),
      appBar: AppBar(
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
        title: Text('User Profile', textAlign: TextAlign.center,style: new TextStyle(fontSize: 30),),
      ),

      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green, Colors.lightGreen],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.5, 0.9],
              )
            ),

            child: Flex(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              direction: Axis.vertical,
              children: <Widget>[
                CircleAvatar(
                  backgroundColor: Color(0xFF101010),
                  minRadius: 60.0,
                  child: CircleAvatar(
                    radius: 50.0,
                    backgroundImage: Image.asset('images/wolf_user.png').image,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  user.name.toString(),
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF101010),
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              children: <Widget>[
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    'E-mail',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    user.email.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.lightGreen,
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'My Quizzes',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                    leading: Icon(Icons.quiz_sharp, color: Colors.lightGreen),
                    onTap: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                            builder: (context) => QuizScreen(quiz: new Quiz(), answers: [],)),
                      );
                    }
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'My Playlists',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: Icon(Icons.queue_music_outlined, color: Colors.lightGreen),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
