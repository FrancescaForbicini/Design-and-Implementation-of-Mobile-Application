import 'dart:core';
import 'package:spotify/spotify.dart' as sp;
import '../models/question.dart';


class QuestionsPlaylist {

  static QuestionsPlaylist _questionsPlaylist = QuestionsPlaylist._QuestionsPlaylistConstructor();

  factory QuestionsPlaylist() => _questionsPlaylist ??= QuestionsPlaylist._QuestionsPlaylistConstructor();

  QuestionsPlaylist._QuestionsPlaylistConstructor();



  Future<void> buildQuestionsPlaylist(List<Question> questions, List<sp.Track> tracks,List questionsFromJSON) async{
    tracks.shuffle();
    List<String> allArtists = getAllArtists(tracks);
    List<String?> allAlbums = getAllAlbums(tracks);
    List<String> allTracks = getAllTracks(tracks);
    int i = 0;
    int typeQuestion = 0;

    for (i = 0; i < tracks.length; i++) {
      Question question = Question();

      if (typeQuestion > questionsFromJSON.length) {
        typeQuestion = 0;
      }

      question.question1 = questionsFromJSON[typeQuestion]["question1"];
      question.question2 = questionsFromJSON[typeQuestion]["question2"];

      List<String?> wrongAnswers = [];

      switch (typeQuestion) {
        case 0:
          {
            question.artistAlbum = tracks[i].name;
            sp.Artist artist = tracks[i].artists![0];
            question.rightAnswer = artist.name.toString();
            wrongAnswers = allArtists.where((element) => element != artist.name.toString()).toList();
            break;
          }

        case 1:
          {
            question.artistAlbum = tracks[i].name;
            sp.AlbumSimple? album = tracks[i].album;
            question.rightAnswer = album!.name.toString();
            wrongAnswers = allAlbums.where((element) => element != album.name).toList();
            break;
          }

        case 2:
          {
            sp.Track track = tracks[i];
            question.url = track.previewUrl.toString();
            question.isPresent = true;
            question.rightAnswer = track.name.toString();
            wrongAnswers = allTracks.where((element) => element != tracks[i].name).toList();

            break;
          }
      }
      question.wrongAnswers = setWrongAnswersTracks(wrongAnswers);

      questions.add(question);
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