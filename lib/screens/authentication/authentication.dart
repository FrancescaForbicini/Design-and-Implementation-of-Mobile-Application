import 'package:auto_size_text/auto_size_text.dart';
import 'package:dima_project/screens/authentication/sign_in/signin.dart';
import 'package:dima_project/screens/authentication/sign_up/signup.dart';
import 'package:dima_project/screens/settings/acquire_position.dart';
import 'package:dima_project/screens/spotifyAuth_screen.dart';
import 'package:flutter/material.dart';

import '../../services/authentication_service.dart';

class AuthenticationScreen extends StatelessWidget{
  AuthenticationScreen({super.key});

  final AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    final _height = _screenHeight - _statusBarHeight;

    AcquirePosition().handleLocationPermission(context);

    return Scaffold(
      backgroundColor: Color (0xFF101010),
      body: Container(
        width: _screenWidth,
        height: _height,
        child:
            // FutureBuilder(
            //   future: AcquirePosition().handleLocationPermission(context),
            //   builder: (BuildContext context, AsyncSnapshot snapshot) {
            //     if (snapshot.hasData && snapshot.data == true) {
                  Column(
                      children: <Widget>[
                        Image.asset(
                            'images/logo.png',
                            width: _screenWidth,
                            height: _height * 0.5,
                            alignment: Alignment.bottomCenter
                        ),
                        Container(
                          width: _screenWidth,
                          height: _height * 0.16,
                          child: TextButton(
                            child: AutoSizeText(
                              'Sign in',
                              style: TextStyle(fontSize: 20.0,
                                  fontFamily: 'Hind',
                                  color: Colors.lightGreen),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    SignInScreen()),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: _screenWidth,
                          height: _height * 0.16,
                          child: TextButton(
                            child: AutoSizeText(
                              'Sign up',
                              style: TextStyle(fontSize: 20.0,
                                  fontFamily: 'Hind',
                                  color: Colors.lightGreen),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    SignUpScreen()),
                              );
                            },
                          ),
                        ),
                        Container(
                          width: _screenWidth,
                          height: _height * 0.16,
                          child: TextButton(
                            child: AutoSizeText(
                              'Sign in with Google',
                              style: TextStyle(fontSize: 20.0,
                                  fontFamily: 'Hind',
                                  color: Colors.lightGreen),
                            ),
                            onPressed: () =>
                            {
                              _authService.signInWithGoogle(context),
                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => SpotifyScreen()),)
                            },
                          ),
                        ),
                      ]
                  //);
                //}
                // return CircularProgressIndicator();
              //}


      )


        ),
    );
  }
}