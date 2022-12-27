import 'package:auto_size_text/auto_size_text.dart';
import 'package:dima_project/services/spotify_service.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'home/home_screen.dart';

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
    final _appBar = AppBar(
      title: const AutoSizeText(
        'Authorize access to Spotify',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30),
      ),
      backgroundColor: Colors.lightGreen,
    );
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _appBarHeight = _appBar.preferredSize.height;
    final _statusBarHeight = MediaQuery.of(context).padding.top;
    final _height = _screenHeight - _appBarHeight - _statusBarHeight;

    return Scaffold(
      backgroundColor: Color (0xFF101010),
      appBar: _appBar,
      body: Container(
        width: _screenWidth,
        height: _height,
        child: FutureBuilder(
          future: _done,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            Widget child;
            if (snapshot.connectionState == ConnectionState.done){
              print(snapshot);
              child = WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: _spotifyService.getAuthUri().toString(),
                navigationDelegate: (navReq) async {
                  if (navReq.url.startsWith(_spotifyService.getRedirectUri())) {
                    responseUri = navReq.url;
                    await _handleResponse(responseUri);

                    return NavigationDecision.prevent;
                  }
                  //TODO check if it creates problems
                  return NavigationDecision.navigate;
                },
              );

              return child;
            }
            else{
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.lightGreen,
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _handleResponse(responseUri) async{
    _spotifyService.handleResponse(Uri.parse(responseUri), context);
  }
}