import 'dart:convert';
import 'dart:io';

import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/authentication.dart';
import 'package:dima_project/services/authentication/sign_up/signup.dart';
import 'package:dima_project/services/spotify_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spotify/spotify.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SpotifyScreen extends StatelessWidget{
  SpotifyScreen({super.key});

  final SpotifyService _spotifyService = SpotifyService();

  @override
  Widget build(BuildContext context){
    _spotifyService.init();
    var authUri = _spotifyService.getAuthUri();
    var redirectUri = _spotifyService.getRedirectUri();
    var responseUri;

    return Scaffold(
      backgroundColor: Color (0xFF101010),
      appBar: AppBar(
        title: Text('Authorize access to Spotify'),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: authUri.toString(),
            navigationDelegate: (navReq) {
              if (navReq.url.startsWith(redirectUri.toString())) {
                responseUri = navReq.url;
                _spotifyService.handleResponse(responseUri);
                return NavigationDecision.prevent;
              }

              return NavigationDecision.navigate;
            },
          )
        ],
      ),
    );
  }
}