import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_project/screens/home/home_screen.dart';
import 'package:dima_project/screens/spotifyAuth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as spotify_dart;

import '../../../customized_app_bar.dart';
import '../../../generated/l10n.dart';
import '../../../services/authentication_service.dart';
import '../../../services/spotify_service.dart';
import '../sign_up/signup.dart';

bool isTest = false;

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();
  Color? textColor;

  @override
  Widget build(BuildContext context) {
    final _appBar = CustomizedAppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back,
            color: Theme.of(context).iconTheme.color, size: 30),
        onPressed: () => {
          Navigator.pop(context),
        },
      ),
      title: AutoSizeText(
        S.of(context).SigninTitle,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
      ),
    );
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _appBarHeight = _appBar.preferredSize.height;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    final _height = _screenHeight - _appBarHeight - _statusBarHeight;

    return Scaffold(
      appBar: _appBar,
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: _height,
        width: _screenWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildEmailTextField(context),
            SizedBox(
              height: _height * 0.05,
            ),
            _buildPasswordTextField(context),
            SizedBox(
              height: _height * 0.05,
            ),
            _buildButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailTextField(BuildContext context) {
    return TextFormField(
        key: const Key('email_text_input'),
        controller: _emailController,
        validator: (value) => EmailFieldValidator.validate(value!),
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: S.of(context).SigninEmail,
            filled: true,
            icon: const Icon(
              Icons.email,
              color: Colors.lightGreen,
            ),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Theme.of(context).iconTheme.color!, width: 2.0)),
            labelStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
                fontFamily: 'Calibri')));
  }

  Widget _buildPasswordTextField(BuildContext context) {
    return TextFormField(
      key: const Key('password_text_input'),
      controller: _passwordController,
      validator: (value) => PasswordFieldValidator.validate(value!),
      decoration: InputDecoration(
          labelText: S.of(context).SigninPwd,
          filled: true,
          icon: const Icon(Icons.key, color: Colors.lightGreen),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).iconTheme.color!, width: 2.0)),
          labelStyle: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w400,
              fontFamily: 'Calibri')),
      obscureText: true,
    );
  }

  Widget _buildButton(BuildContext context) {
    Future<bool> done;
    return MaterialButton(
        key: const Key('sign_in_button'),
        color: Colors.lightGreen,
        textColor: Colors.white,
        child: AutoSizeText(S.of(context).SigninButton),
        onPressed: () => {
              done = _authService.signIn(
                  _emailController.text, _passwordController.text),
              done.then((value) => {
                    if (value)
                      {
                        if (isTest)
                          {
                            setToken(context),
                            Navigator.pop(context),
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen())),
                          }
                        else
                          {
                            Navigator.pop(context),
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SpotifyScreen()),
                            )
                          }
                      }
                    else
                      {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text(S.of(context).SigninErr),
                                content: Text(S.of(context).SigninErrText),
                                actions: [
                                  MaterialButton(
                                    child: Text(S.of(context).SigninErrButton),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  )
                                ],
                              );
                            })
                      }
                  }),
            });
  }

  void setToken(context) async {
    SpotifyService spotifyService = SpotifyService();
    var email = 'francesca.forbicini@gmail.com';
    spotify_dart.SpotifyApiCredentials spotifyCredentials =
        await spotifyService.getCredentials(email);
    print("Got the credentials");
    spotifyService.spotify = spotify_dart.SpotifyApi(spotifyCredentials);
    print("Created API");
    try {
      spotifyService.spotify.me.get();
      spotifyService.saveCredentials();
      print("Saved credentials");
    } catch (e) {
      print("Error");
    }
  }
}
