import 'dart:convert';
import 'dart:io';

import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/authentication/authentication.dart';
import 'package:dima_project/services/authentication_service.dart';
import 'package:dima_project/services/spotify_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget{
  final AuthenticationService _authenticationService = AuthenticationService();
  final SpotifyService _spotifyService = SpotifyService();

  HomeScreen({super.key});

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

  Widget _buildPlaylists(){
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[

      ],
    );
  }

  Widget _buildArtists(){
    return ListView(
      scrollDirection: Axis.horizontal,
      children: <Widget>[

      ],
    );
  }
}