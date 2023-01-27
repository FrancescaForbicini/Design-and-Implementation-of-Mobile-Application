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
    final Color? textColor = Theme.of(context).textTheme.bodyText1?.color;
    AcquirePosition().handleLocationPermission(context);

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
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
                key: const Key('sign_in_button'),
                child: AutoSizeText(
                  S.of(context).AuthSignin,
                  style: TextStyle(fontSize: 20.0,fontFamily: 'Hind', color: textColor),
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
                key: const Key('sign_up_button'),
                child: AutoSizeText(
                  S.of(context).AuthSignup,
                  style: TextStyle(fontSize: 20.0,fontFamily: 'Hind', color: textColor),
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
                key: const Key('sign_google_button'),
                child: AutoSizeText(
                  S.of(context).AuthGoogle,
                  style: TextStyle(fontSize: 20.0,fontFamily: 'Hind', color: textColor),
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