// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Invalid Email`
  String get SignupErrEmail {
    return Intl.message(
      'Invalid Email',
      name: 'SignupErrEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password cannot be empty or shorter than 6 characters`
  String get SignupErrPwd {
    return Intl.message(
      'Password cannot be empty or shorter than 6 characters',
      name: 'SignupErrPwd',
      desc: '',
      args: [],
    );
  }

  /// `The passwords do not match`
  String get SignupErrMatchPwd {
    return Intl.message(
      'The passwords do not match',
      name: 'SignupErrMatchPwd',
      desc: '',
      args: [],
    );
  }

  /// `Username cannot be empty`
  String get SignupEmptyUser {
    return Intl.message(
      'Username cannot be empty',
      name: 'SignupEmptyUser',
      desc: '',
      args: [],
    );
  }

  /// `Sign Up`
  String get SignupTitle {
    return Intl.message(
      'Sign Up',
      name: 'SignupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get SignupEmail {
    return Intl.message(
      'Email',
      name: 'SignupEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get SignupPwd {
    return Intl.message(
      'Password',
      name: 'SignupPwd',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get SignupConfirmPwd {
    return Intl.message(
      'Confirm Password',
      name: 'SignupConfirmPwd',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get SignupUser {
    return Intl.message(
      'Username',
      name: 'SignupUser',
      desc: '',
      args: [],
    );
  }

  /// `SIGN UP`
  String get SignupButton {
    return Intl.message(
      'SIGN UP',
      name: 'SignupButton',
      desc: '',
      args: [],
    );
  }

  /// `Sign In`
  String get SigninTitle {
    return Intl.message(
      'Sign In',
      name: 'SigninTitle',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get SigninEmail {
    return Intl.message(
      'Email',
      name: 'SigninEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get SigninPwd {
    return Intl.message(
      'Password',
      name: 'SigninPwd',
      desc: '',
      args: [],
    );
  }

  /// `SIGN IN`
  String get SigninButton {
    return Intl.message(
      'SIGN IN',
      name: 'SigninButton',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get SigninErr {
    return Intl.message(
      'Error',
      name: 'SigninErr',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password`
  String get SigninErrText {
    return Intl.message(
      'Invalid email or password',
      name: 'SigninErrText',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get SigninErrButton {
    return Intl.message(
      'Ok',
      name: 'SigninErrButton',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get AuthSignin {
    return Intl.message(
      'Sign in',
      name: 'AuthSignin',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get AuthSignup {
    return Intl.message(
      'Sign up',
      name: 'AuthSignup',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get AuthGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'AuthGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Home Page`
  String get HomeTitle {
    return Intl.message(
      'Home Page',
      name: 'HomeTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start a new quiz!`
  String get HomeStart {
    return Intl.message(
      'Start a new quiz!',
      name: 'HomeStart',
      desc: '',
      args: [],
    );
  }

  /// `Your playlists:`
  String get HomePlaylist {
    return Intl.message(
      'Your playlists:',
      name: 'HomePlaylist',
      desc: '',
      args: [],
    );
  }

  /// `Your artists:`
  String get HomeArtists {
    return Intl.message(
      'Your artists:',
      name: 'HomeArtists',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any playlist yet!`
  String get HomeErrPlaylist {
    return Intl.message(
      'You don\'t have any playlist yet!',
      name: 'HomeErrPlaylist',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any favourite artist yet!`
  String get HomeErrArtists {
    return Intl.message(
      'You don\'t have any favourite artist yet!',
      name: 'HomeErrArtists',
      desc: '',
      args: [],
    );
  }

  /// `User Profile`
  String get UserTitle {
    return Intl.message(
      'User Profile',
      name: 'UserTitle',
      desc: '',
      args: [],
    );
  }

  /// `Best Score: {bestScore}`
  String UserBestScore(Object bestScore) {
    return Intl.message(
      'Best Score: $bestScore',
      name: 'UserBestScore',
      desc: '',
      args: [bestScore],
    );
  }

  /// `E-mail`
  String get UserEmail {
    return Intl.message(
      'E-mail',
      name: 'UserEmail',
      desc: '',
      args: [],
    );
  }

  /// `My Playlists`
  String get UserPlaylists {
    return Intl.message(
      'My Playlists',
      name: 'UserPlaylists',
      desc: '',
      args: [],
    );
  }

  /// `New Quiz`
  String get QuizGenTitle {
    return Intl.message(
      'New Quiz',
      name: 'QuizGenTitle',
      desc: '',
      args: [],
    );
  }

  /// `Score: {totalScore}   Level: {level}`
  String QuizGenScore(Object totalScore, Object level) {
    return Intl.message(
      'Score: $totalScore   Level: $level',
      name: 'QuizGenScore',
      desc: '',
      args: [totalScore, level],
    );
  }

  /// `You got {questionNumber} questions right!`
  String QuizGenNextLevel(Object questionNumber) {
    return Intl.message(
      'You got $questionNumber questions right!',
      name: 'QuizGenNextLevel',
      desc: '',
      args: [questionNumber],
    );
  }

  /// `Press the button Continue to go to the level {level}\nOtherwise press the button Exit\n`
  String QuizGenNextMessage(Object level) {
    return Intl.message(
      'Press the button Continue to go to the level $level\nOtherwise press the button Exit\n',
      name: 'QuizGenNextMessage',
      desc: '',
      args: [level],
    );
  }

  /// `Continue`
  String get QuizGenGoOnButton {
    return Intl.message(
      'Continue',
      name: 'QuizGenGoOnButton',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get QuizGenExitButton {
    return Intl.message(
      'Exit',
      name: 'QuizGenExitButton',
      desc: '',
      args: [],
    );
  }

  /// `You missed a question!`
  String get ResultTitle {
    return Intl.message(
      'You missed a question!',
      name: 'ResultTitle',
      desc: '',
      args: [],
    );
  }

  /// `You got {score}`
  String ResultMessage(Object score) {
    return Intl.message(
      'You got $score',
      name: 'ResultMessage',
      desc: '',
      args: [score],
    );
  }

  /// `Exit`
  String get ResultButton {
    return Intl.message(
      'Exit',
      name: 'ResultButton',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get ResultPhoto {
    return Intl.message(
      '',
      name: 'ResultPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Authorize access to Spotify`
  String get SpotyTitle {
    return Intl.message(
      'Authorize access to Spotify',
      name: 'SpotyTitle',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'it'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
