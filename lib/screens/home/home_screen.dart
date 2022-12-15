import 'dart:convert';
import 'dart:io';

import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/authentication/authentication.dart';
import 'package:dima_project/services/authentication_service.dart';
import 'package:dima_project/services/spotify_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as sp;

import '../../models/quiz.dart';
import '../../services/quiz_generator.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  final AuthenticationService _authenticationService = AuthenticationService();
  final SpotifyService _spotifyService = SpotifyService();
  late var _userId;
  late var _username;
  late List _playlists;
  late List _artists;
  late Future<bool> _done;

  @override
  void initState() {
    _done = _startup();
    super.initState();
  }

  Future<bool> _startup() async{
    print("Debugging here in startup method");
    var _user = await _spotifyService.spotify.me.get();
    print("User spotify: $_user");
    print("User spotify info: ${_user.displayName}, ${_user.country}, ${_user.product}, ${_user.id}");
    _userId = _user.id;
    _username = _user.displayName;
    print("Got the userid");
    print("UserID: $_userId");
    var _playlistsRef = _spotifyService.spotify.playlists;
    print("Got reference to playlists: ${_playlistsRef.runtimeType}");
    if(_playlistsRef != null){
      print("The reference exists!");
    }
    Iterable<sp.PlaylistSimple> playlists = await _playlistsRef.me.all();
    print("Got the playlists");
    print(playlists.runtimeType);
    _playlists = playlists.toList();
    Iterable<sp.Artist> artists = await _spotifyService.spotify.me.topArtists();
    print(artists.runtimeType);
    _artists = artists.toList();

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final _appBar = AppBar(
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
    );
    final _screenHeight = MediaQuery.of(context).size.height;
    final _screenWidth = MediaQuery.of(context).size.width;
    final _appBarHeight = _appBar.preferredSize.height;
    final _statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Color(0xFF101010),
      appBar: _appBar,

      body: _buildHomeBody(_screenHeight - _appBarHeight - _statusBarHeight, _screenWidth),
    );
  }

  Widget _buildHomeBody(height, width){
    return ListView(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: <Widget>[
        Container(
          color: Color(0xFF101010),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Color(0xFF101010),
                width: width,
                height: height * 0.1,
                child: Text(
                  "Start a new quiz!",
                  style: TextStyle(
                    color: Colors.lightGreen,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                color: Color(0xFF101010),
                width: width,
                height: height * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Color(0xFF101010),
                      width: width,
                      height: height * 0.05,
                      child: Text(
                        "Your playlists:",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xFF101010),
                      width: width,
                      height: height * 0.4,
                      child: _buildPlaylists(height, width),
                    )
                  ],
                ),
              ),
              Container(
                color: Color(0xFF101010),
                width: width,
                height: height * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Color(0xFF101010),
                      width: width,
                      height: height * 0.05,
                      child: Text(
                        "Your artists:",
                        style: TextStyle(
                          color: Colors.lightGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Color(0xFF101010),
                      width: width,
                      height: height * 0.4,
                      child: _buildArtists(height, width),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildPlaylists(height, width) {
    return FutureBuilder(
      future: _done,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget child;
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done){
          child = ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _playlists.length,
            itemBuilder: (context, index){
              return Container(
                color: Color(0xFF101010),
                width: width * 0.3,
                height: height * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: Ink.image(
                          width: width * 0.2,
                          height: height * 0.2,
                          image: Image.network(_playlists[index].images[0].url).image,
                        ),
                        onTap:()=>{

                        Navigator.push(context,
                        MaterialPageRoute(
                        builder: (context) => QuizGenerator(_playlists)))
                        } ,
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                      height: height * 0.1,
                      child: Text(
                        _playlists[index].name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );

          return child;
        }
        else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.lightGreen,
            ),
          );
        }
      },
    );
  }

  Widget _buildArtists(height, width){
    return FutureBuilder(
      future: _done,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        Widget child;
        if (snapshot.hasData && snapshot.connectionState == ConnectionState.done){
          child = ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _artists.length,
            itemBuilder: (context, index){
              return Container(
                color: Color(0xFF101010),
                width: width * 0.3,
                height: height * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        child: Ink.image(
                          width: width * 0.2,
                          height: height * 0.2,
                          //fit: BoxFit.cover,
                          image: Image.network(_artists[index].images[0].url).image,
                        ),
                        //TODO implement onTap
                        //onTap: ,
                      ),
                    ),
                    Container(
                      width: width * 0.2,
                      height: height * 0.1,
                      child: Text(
                        _artists[index].name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),
                      ),
                    )
                  ],
                ),
              );
/*              return ListTile(
                leading: Image.network(_artists[index].images[0].url),
                title: Text(_artists[index].name, style: TextStyle(fontSize: 15)),
              );*/
            },
          );

          return child;
        }
        else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.lightGreen,
            ),
          );
        }
      },
    );
  }
}