import 'dart:convert';
import 'dart:io';

import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/authentication.dart';
import 'package:dima_project/services/authentication/sign_up/signup.dart';
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
  late var _spotify;
  late var _grant;

  factory SpotifyService() => _spotifyService ??= SpotifyService._SpotifyServiceConstructor();

  SpotifyService._SpotifyServiceConstructor();

  Future<bool> init() async {
/*    _keyJson = await File('json/spotify.json').readAsString();*/
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
    _spotify = SpotifyApi.fromClient(client);

    if (_spotify == null) {
      print("Something went wrong!");
    }
    else {
      print("Spotify done!");
    }
  }

/*  Future<SpotifyApi?> _getUserAuthenticatedSpotifyApi(SpotifyApiCredentials credentials, redirectUri) async {

    var authUri = grant.getAuthorizationUrl(Uri.parse(redirectUri!), scopes: _scopes);

    await redirect(authUri);
    final responseUri = await listen(redirectUri);

    var client = await grant.handleAuthorizationResponse(responseUri);
    return SpotifyApi.fromClient(client);
  }

  redirect(authUri){

  }

  listen(redirectUri){

  }*/
}