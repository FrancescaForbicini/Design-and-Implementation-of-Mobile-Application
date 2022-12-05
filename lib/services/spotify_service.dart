import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:spotify/spotify.dart';

const _scopes = [
  'playlist-read-private',
  'playlist-read-collaborative',
  'user-follow-read',
  'user-top-read',
  'user-read-recently-played',
  'user-library-read'
];

class SpotifyService {
  static SpotifyService _spotifyService = SpotifyService._SpotifyServiceConstructor();

  late var _keyJson;
  late var _keyMap;
  late var _credentials;
  late var _authUri;
  late var _redirectUri;
  late var spotify;
  late var _grant;

  factory SpotifyService() => _spotifyService ??= SpotifyService._SpotifyServiceConstructor();

  SpotifyService._SpotifyServiceConstructor();

  Future<bool> init() async {
    _keyJson = await rootBundle.loadString('json/spotify.json');
    _keyMap = json.decode(_keyJson);
    _credentials = SpotifyApiCredentials(_keyMap['id'], _keyMap['secret']);
    _redirectUri = _keyMap['redirect_uri'];
    _grant = SpotifyApi.authorizationCodeGrant(_credentials);
    _authUri = _grant.getAuthorizationUrl(Uri.parse(_redirectUri!), scopes: _scopes);

    return true;
  }

  Uri getAuthUri(){
    return _authUri;
  }

  String getRedirectUri(){
    return _redirectUri;
  }

  void handleResponse(Uri responseUri) async{
    var client = await _grant.handleAuthorizationResponse(responseUri.queryParameters);
    spotify = SpotifyApi.fromClient(client);

    if (spotify == null) {
      print("Something went wrong!");
    }
    else {
      print("Spotify done!");
      // TODO check if it is working
      saveCredentials();
    }
  }

  void saveCredentials(){
    var user = FirebaseAuth.instance.currentUser;
    var credentials = spotify.getCredentials();

    FirebaseFirestore.instance.collection("users").doc(user?.email).set({
      "clientId": credentials.clientId,
      "clientSecret": credentials.clientSecret,
      "accessToken": credentials.accessToken,
      "refreshToken": credentials.accessToken,
      "scopes": credentials.scopes,
      "expiration": credentials.expiration
    });
  }

  SpotifyApiCredentials getCredentials(user){
    var data;
    var spotifyCredentials;
    final docRef = FirebaseFirestore.instance.collection("users").doc(user.email);
    docRef.get().then((DocumentSnapshot doc) {
      data = doc.data() as Map<String, dynamic>;
      spotifyCredentials = SpotifyApiCredentials(
          data["clientId"],
          data["clientSecret"],
          accessToken: data["accessToken"],
          refreshToken: data["refreshToken"],
          scopes: data["scopes"],
          expiration: data["expiration"]
      );
    },
      onError: (e) => print("Error getting document: $e"),
    );
    return spotifyCredentials;
  }
}