import 'package:flutter/material.dart';

import '../../models/quiz.dart';
import '../../models/user.dart';
import '../../services/authentication/authentication.dart';
import 'following_screen.dart';

class UserProfile extends StatelessWidget {
  final List<User> userfollow = [new User(id: '1', name:'raff' , surname:'kik', username:'rocket', email: 'rocket@ann')];
  final User user = new User(id: '1', name: 'francesca', surname: 'forbicini', email: 'francesca.forbicini@gmail.com',username:'frafra');
  UserProfile({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User Profile',
      home: Scaffold(
        backgroundColor: Color(0xFF101010),
        appBar: AppBar(
          backgroundColor: Color (0xFF101010),
          leading: IconButton(
              icon: Icon(Icons.logout, color: Colors.lightGreen),
                  onPressed:(){ Navigator.push(context,
                  MaterialPageRoute(
                  builder: (context) => AutenticationScreen()));
              }),
          title: Text('User Profile', textAlign: TextAlign.center,),
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

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Expanded(
                      child: Container(
                        color: Color(0xFF101010),
                        child: ListTile(
                          title: Text(
                            userfollow.length.toString(),                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                              color: Colors.green,
                            ),
                          ),
                          subtitle: Text(
                            'Followers',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.green,
                            ),
                          ),
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FollowingScreen()),
                            );
                          },
                        ),
                      ),
                  ),
                  Expanded(
                    child: Container(
                      color: Color(0xFF101010),
                      child: ListTile(
                        title: Text(
                          userfollow.length.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Colors.lightGreen,
                          ),
                        ),
                        subtitle: Text(
                          'Following',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.lightGreen,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context,
                            MaterialPageRoute(
                                builder: (context) => FollowingScreen()),
                          );
                        }
                      )
                    ),
                  ),
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
                      'My quizzes',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: Text(
                      'My playlists',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
