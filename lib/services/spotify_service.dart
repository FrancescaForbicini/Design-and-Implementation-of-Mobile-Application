import 'dart:convert';
import 'dart:io';

import 'package:dima_project/screens/profile/userprofile_screen.dart';
import 'package:dima_project/screens/authentication.dart';
import 'package:dima_project/services/authentication/sign_up/signup.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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

  void init() async {
    var keyJson = await File('json/spotify.json').readAsString();
    var keyMap = json.decode(keyJson);
    var credentials = SpotifyApiCredentials(keyMap['id'], keyMap['secret']);
    var redirect = keyMap['redirect_uri'];
    var spotify = await _getUserAuthenticatedSpotifyApi(credentials, redirect);

    if (spotify == null) {
      print("Something went wrong!");
    }
    else {
      print("Spotify done!");
    }
  }

  Future<SpotifyApi?> _getUserAuthenticatedSpotifyApi(SpotifyApiCredentials credentials, redirectUri) async {
    var grant = SpotifyApi.authorizationCodeGrant(credentials);
    var authUri = grant.getAuthorizationUrl(Uri.parse(redirectUri!), scopes: _scopes);

    await redirect(authUri);
    final responseUri = await listen(redirectUri);

    var client = await grant.handleAuthorizationResponse(responseUri);
    return SpotifyApi.fromClient(client);
  }

  redirect(authUri){

  }

  listen(redirectUri){

  }
}