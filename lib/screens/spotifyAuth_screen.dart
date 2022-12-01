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

class SpotifyScreen extends StatefulWidget {
  const SpotifyScreen({super.key});

  @override
  State<SpotifyScreen> createState() => _SpotifyScreenState();
}

class _SpotifyScreenState extends State<SpotifyScreen>{
  final SpotifyService _spotifyService = SpotifyService();
  late final Future<bool> _done;

  @override
  void initState() {
    _done = _spotifyService.init();
  }


  @override
  Widget build(BuildContext context){
    var responseUri;

    return Scaffold(
      backgroundColor: Color (0xFF101010),
      appBar: AppBar(
        title: Text('Authorize access to Spotify'),
        backgroundColor: Colors.lightGreen,
      ),
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          FutureBuilder(
            future: _done,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              Widget child;
              if (snapshot.connectionState == ConnectionState.done){
                print(snapshot);
                child = Container(
                  height: 500,
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _spotifyService.getAuthUri().toString(),
                    navigationDelegate: (navReq) {
                      if (navReq.url.startsWith(_spotifyService.getRedirectUri())) {
                        responseUri = navReq.url;
                        _spotifyService.handleResponse(responseUri);
                        return NavigationDecision.prevent;
                      }

                      return NavigationDecision.navigate;
                    },
                  ),
                );

                return child;
              }
              else {
                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }
}