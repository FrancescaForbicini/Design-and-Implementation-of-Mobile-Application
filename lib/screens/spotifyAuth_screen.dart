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
                child = Expanded(
                  flex: 1,
                  child: WebView(
                    javascriptMode: JavascriptMode.unrestricted,
                    initialUrl: _spotifyService.getAuthUri().toString(),
                    navigationDelegate: (navReq) {
                      if (navReq.url.startsWith(_spotifyService.getRedirectUri())) {
                        responseUri = navReq.url;
                        _spotifyService.handleResponse(Uri.parse(responseUri));
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
          ),
        ],
      ),
    );
  }
}