import 'package:dima_project/screens/authentication/sign_in/signin.dart';
import 'package:dima_project/screens/authentication/sign_up/signup.dart';
import 'package:dima_project/screens/spotifyAuth_screen.dart';
import 'package:flutter/material.dart';

import '../../services/authentication_service.dart';

class AuthenticationScreen extends StatelessWidget{
  AuthenticationScreen({super.key});

  final AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color (0xFF101010),
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
            Image.asset('images/logo.png',width: 400,height: 350, alignment: Alignment.bottomCenter),
            Container(
              margin: EdgeInsets.all(30),
              child: TextButton(
                child: Text(
                  'Sign in',
                  style: TextStyle(fontSize: 20.0,fontFamily: 'Hind', color: Colors.lightGreen),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
              child: TextButton(
                child: Text(
                  'Sign up',
                  style: TextStyle(fontSize: 20.0,fontFamily: 'Hind', color: Colors.lightGreen),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
              ),
            ),
            Container(
              margin: EdgeInsets.all(30),
              child: TextButton(
                child: Text(
                  'Sign in with Google',
                  style: TextStyle(fontSize: 20.0,fontFamily: 'Hind', color: Colors.lightGreen),
                ),
                onPressed: () => {
                  _authService.signInWithGoogle(context),
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SpotifyScreen()),)
                },
              ),
            ),
        ],
      ),
    );
  }
}