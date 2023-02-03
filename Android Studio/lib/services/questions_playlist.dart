import 'dart:core';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as sp;
import '../generated/l10n.dart';
import '../models/question.dart';


class QuestionsPlaylist {

  static QuestionsPlaylist _questionsPlaylist = QuestionsPlaylist._QuestionsPlaylistConstructor();

  factory QuestionsPlaylist() => _questionsPlaylist ??= QuestionsPlaylist._QuestionsPlaylistConstructor();

  QuestionsPlaylist._QuestionsPlaylistConstructor();

  List<String> allArtists = [];
  List<String?> allAlbums = [];
  List<String> allTracks = [];

  void buildAllAnswersQuestions(List<sp.Track> tracks){
    allArtists = getAllArtists(tracks);
    allAlbums = getAllAlbums(tracks);
    allTracks = getAllTracks(tracks);
  }

  Future<void> buildQuestionsPlaylist(List<Question> questions, List<sp.Track> tracks, List questionsFromJSON) async{
    buildAllAnswersQuestions(tracks);
    tracks.shuffle();

    int i = 0;
    int typeQuestion = 0;

    for (i = 0; i < tracks.length; i++) {
      Question question = Question();

      if (typeQuestion > questionsFromJSON.length - 1) {
        typeQuestion = 0;
      }

/*      question.question1 = questionsFromJSON[typeQuestion]["question1"];
      question.question2 = questionsFromJSON[typeQuestion]["question2"];*/

      List<String?> wrongAnswers = [];

      switch (typeQuestion) {
        case 0:
          {
            question.question1 = S.current.QuestionPlaylist11;
            question.question2 = S.current.QuestionPlaylist12;
            question.artistAlbum = tracks[i].name;
            sp.Artist artist = tracks[i].artists![0];
            question.rightAnswer = artist.name.toString();
            wrongAnswers = allArtists.where((element) => element != artist.name.toString()).toList();
            question.wrongAnswers = setWrongAnswersTracks(wrongAnswers);
            questions.add(question);

            break;
          }

        case 1:
          {
            question.question1 = S.current.QuestionPlaylist21;
            question.question2 = S.current.QuestionPlaylist22;
            question.artistAlbum = tracks[i].name;
            sp.AlbumSimple? album = tracks[i].album;
            question.rightAnswer = album!.name.toString();
            wrongAnswers = allAlbums.where((element) => element != album.name).toList();
            question.wrongAnswers = setWrongAnswersTracks(wrongAnswers);
            questions.add(question);

            break;
          }

        case 2:
          {
            question.question1 = S.current.QuestionPlaylist31;
            question.question2 = S.current.QuestionPlaylist32;
            sp.Track track = tracks[i];
            if (track.previewUrl != null){
              question.url = track.previewUrl!;
              question.isPresent = true;
              question.rightAnswer = track.name.toString();
              wrongAnswers = allTracks.where((element) => element != tracks[i].name).toList();
              question.wrongAnswers = setWrongAnswersTracks(wrongAnswers);
              questions.add(question);

            }

            break;
          }
      }

      typeQuestion++;
    }
    questions.shuffle();
  }

  List<String> getAllTracks(List<sp.Track> tracks){
    List<String> allTracks = List.empty(growable: true);
    int i = 0;
    for (i = 0; i < tracks.length; i++) {
      sp.Track track = tracks[i];
      if (!allTracks.contains(track.name.toString())) {
        allTracks.add(track.name.toString());
      }
    }
    return allTracks;
  }

  List<String?> getAllAlbums(List<sp.Track> tracks){
    List<String?> allAlbums = List.empty(growable: true);
    int i = 0;
    for (i = 0; i < tracks.length; i++) {
      sp.AlbumSimple? album = tracks[i].album;
      if (!allAlbums.contains(album?.name.toString())) {
        allAlbums.add(album?.name.toString());
      }
    }
    return allAlbums;
  }

  List<String> getAllArtists(List<sp.Track> tracks){
    List<String> allArtists = List.empty(growable: true);
    int i = 0;
    for (i = 0; i < tracks.length; i++) {
      sp.Artist artist = tracks[i].artists![0];
      if (!allArtists.contains(artist.name.toString())) {
        allArtists.add(artist.name.toString());
      }
    }
    return allArtists;
  }


  List<String> setWrongAnswersTracks (List allWrongAnswers){
    List<String> wrongAnswers = [];
    int i = 0;
    allWrongAnswers.shuffle();
    for (i = 0; i < 3; i++){
      wrongAnswers.add(allWrongAnswers[i]);
    }
    return wrongAnswers;
  }

}