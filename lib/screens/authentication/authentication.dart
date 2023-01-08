import 'package:auto_size_text/auto_size_text.dart';
import 'package:dima_project/screens/authentication/sign_in/signin.dart';
import 'package:dima_project/screens/authentication/sign_up/signup.dart';
import 'package:dima_project/screens/spotifyAuth_screen.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../../services/authentication_service.dart';
import '../settings/acquire_position.dart';

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
        child: Column(
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
                  S.of(context).AuthSignin,
                  style: const TextStyle(fontSize: 20.0,fontFamily: 'Hind', color: Colors.lightGreen),
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
              width: _screenWidth,
              height: _height * 0.16,
              child: TextButton(
                child: AutoSizeText(
                  S.of(context).AuthSignup,
                  style: const TextStyle(fontSize: 20.0,fontFamily: 'Hind', color: Colors.lightGreen),
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
              width: _screenWidth,
              height: _height * 0.16,
              child: TextButton(
                child: AutoSizeText(
                  S.of(context).AuthGoogle,
                  style: const TextStyle(fontSize: 20.0,fontFamily: 'Hind', color: Colors.lightGreen),
                ),
                onPressed: () => {
                  _authService.signInWithGoogle(context),
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SpotifyScreen()),)
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}