import 'dart:convert';
import 'dart:io';

import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/authentication/authentication.dart';
import 'package:dima_project/services/authentication_service.dart';
import 'package:dima_project/services/spotify_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final AuthenticationService _authenticationService = AuthenticationService();
  final SpotifyService _spotifyService = SpotifyService();
  late var _userId;
  late var _playlists;
  late var _artists;
  late Future<bool> _done;

  @override
  void initState() {
    _done = _startup();
  }

  Future<bool> _startup() async{
    _userId = await _spotifyService.spotify.me.get().id;
    _playlists = await _spotifyService.spotify.playlists.getUserPlaylists(_userId);
    _artists = await _spotifyService.spotify.me.topArtists();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Spotify Music Quiz",
      home: Scaffold(
        backgroundColor: Color(0xFF101010),
        appBar: AppBar(
          backgroundColor: Color (0xFF101010),
          leading: IconButton(
            icon: Icon(Icons.logout, color: Colors.lightGreen,size: 30),
            onPressed: () => {
              _authenticationService.signOut(),
              Navigator.push(context, MaterialPageRoute(builder: (context) => AuthenticationScreen()))
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.lightGreen,size: 30),
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserProfile()))
              },
            ),
          ],
          title: Text('Home Page', textAlign: TextAlign.center,style: new TextStyle(fontSize: 30),),
        ),

        body: _buildHomeBody(),
      ),
    );
  }

  Widget _buildHomeBody(){
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        Divider(),
        SizedBox(
          height: 60,
          child: Flex(
            mainAxisSize: MainAxisSize.min,
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  "Start a new quiz!",
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
        Divider(),
        SizedBox(
          height: 200,
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  " Your playlists:",
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildPlaylists(),
              )
            ],
          ),
        ),
        Divider(),
        SizedBox(
          height: 200,
          child: Flex(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 1,
                child: Text(
                  " Your artists:",
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildArtists(),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPlaylists() {
    return FutureBuilder(
      future: _done,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done){
          child = ListView.builder(
            itemCount: _playlists.length,
            itemBuilder: (context, index){
              return ListTile(
                leading: _playlists[index].images[0],
                title: _playlists[index].name,
              );
            },
          );

          return child;
        }
        else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildArtists(){
    return FutureBuilder(
      future: _done,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget child;
        if (snapshot.connectionState == ConnectionState.done){
          child = ListView.builder(
            itemCount: _artists.length,
            itemBuilder: (context, index){
              return ListTile(
                leading: _artists[index].images[0],
                title: _artists[index].name,
              );
            },
          );

          return child;
        }
        else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}