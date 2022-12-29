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

  /// ``
  String get SignupErrEmail {
    return Intl.message(
      '',
      name: 'SignupErrEmail',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SignupErrPwd {
    return Intl.message(
      '',
      name: 'SignupErrPwd',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SignupErrMatchPwd {
    return Intl.message(
      '',
      name: 'SignupErrMatchPwd',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SignupEmptyUser {
    return Intl.message(
      '',
      name: 'SignupEmptyUser',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SignupTitle {
    return Intl.message(
      '',
      name: 'SignupTitle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SignupEmail {
    return Intl.message(
      '',
      name: 'SignupEmail',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SignupPwd {
    return Intl.message(
      '',
      name: 'SignupPwd',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SignupConfirmPwd {
    return Intl.message(
      '',
      name: 'SignupConfirmPwd',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SignupUser {
    return Intl.message(
      '',
      name: 'SignupUser',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SignupButton {
    return Intl.message(
      '',
      name: 'SignupButton',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SigninTitle {
    return Intl.message(
      '',
      name: 'SigninTitle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SigninEmail {
    return Intl.message(
      '',
      name: 'SigninEmail',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SigninPwd {
    return Intl.message(
      '',
      name: 'SigninPwd',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SigninButton {
    return Intl.message(
      '',
      name: 'SigninButton',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SigninErr {
    return Intl.message(
      '',
      name: 'SigninErr',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get SigninErrText {
    return Intl.message(
      '',
      name: 'SigninErrText',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get AuthSignin {
    return Intl.message(
      '',
      name: 'AuthSignin',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get AuthSignup {
    return Intl.message(
      '',
      name: 'AuthSignup',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get AuthGoogle {
    return Intl.message(
      '',
      name: 'AuthGoogle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get HomeTitle {
    return Intl.message(
      '',
      name: 'HomeTitle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get HomeStart {
    return Intl.message(
      '',
      name: 'HomeStart',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get HomePlaylist {
    return Intl.message(
      '',
      name: 'HomePlaylist',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get HomeArtists {
    return Intl.message(
      '',
      name: 'HomeArtists',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get HomeErrPlaylist {
    return Intl.message(
      '',
      name: 'HomeErrPlaylist',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get HomeErrArtists {
    return Intl.message(
      '',
      name: 'HomeErrArtists',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get UserTitle {
    return Intl.message(
      '',
      name: 'UserTitle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get UserBestScore {
    return Intl.message(
      '',
      name: 'UserBestScore',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get UserEmail {
    return Intl.message(
      '',
      name: 'UserEmail',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get UserPlaylists {
    return Intl.message(
      '',
      name: 'UserPlaylists',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get QuizGenTitle {
    return Intl.message(
      '',
      name: 'QuizGenTitle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get QuizGenScore {
    return Intl.message(
      '',
      name: 'QuizGenScore',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get QuizGenNextLevel {
    return Intl.message(
      '',
      name: 'QuizGenNextLevel',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get QuizGenNextMessage {
    return Intl.message(
      '',
      name: 'QuizGenNextMessage',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get QuizGenGoOnButton {
    return Intl.message(
      '',
      name: 'QuizGenGoOnButton',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get QuizGenExitButton {
    return Intl.message(
      '',
      name: 'QuizGenExitButton',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get ResultTitle {
    return Intl.message(
      '',
      name: 'ResultTitle',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get ResultMessage {
    return Intl.message(
      '',
      name: 'ResultMessage',
      desc: '',
      args: [],
    );
  }

  /// ``
  String get ResultButton {
    return Intl.message(
      '',
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

  /// ``
  String get SpotyTitle {
    return Intl.message(
      '',
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
