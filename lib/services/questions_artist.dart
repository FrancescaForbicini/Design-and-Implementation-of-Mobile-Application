import 'dart:core';
import 'dart:math';

import 'package:dima_project/services/spotify_service.dart';
import 'package:spotify/spotify.dart' as sp;
import '../models/question.dart';


class QuestionsArtist {

  static QuestionsArtist _questionsArtist = QuestionsArtist._QuestionsArtistConstructor();

  factory QuestionsArtist() => _questionsArtist ??= QuestionsArtist._QuestionsArtistConstructor();

  QuestionsArtist._QuestionsArtistConstructor();


  Future<void> buildQuestionArtists(List<Question> questions, sp.Artist artist,List questionsFromJSON) async {
    sp.Artists artistsRetrieve = sp.Artists(SpotifyService().spotify);
    List<sp.AlbumSimple?> allAlbums = await getAllAlbums(artist,artistsRetrieve);
    List<List<sp.TrackSimple>> allTracksForAlbum = await getAllTracksForAlbum(allAlbums);
    List<sp.TrackSimple> allTracks = getAllTracks(allTracksForAlbum);
    List<String?> allYearsAlbum = allAlbums.map((e) => e?.releaseDate?.substring(0, 4).toString()).toList();
    int i = 0;
    int typeQuestion = 0;

    for (i = 0; i < allAlbums.length; i++) {
      Question question = Question();

      if (typeQuestion > 3) {
        typeQuestion = 0;
      }

      question.question1 = questionsFromJSON[typeQuestion]["question1"];
      question.question2 = questionsFromJSON[typeQuestion]["question2"];
      question.artistAlbum = allAlbums[i]?.name;

      switch (typeQuestion) {
        case 0:
          {
            String? yearSelected = allAlbums[i]?.releaseDate?.substring(0, 4).toString();
            question.rightAnswer = yearSelected;

            List<String?> wrongYears = allYearsAlbum.where((element) => element != yearSelected).toList();
            question.wrongAnswers = setWrongAnswersYears(wrongYears);

            break;
          }
        case 1:
          {
            List<sp.TrackSimple> rightAnswersTracks = allTracksForAlbum[i];
            allTracks.shuffle();

            int randomTrack = Random().nextInt(rightAnswersTracks.length);
            question.rightAnswer = rightAnswersTracks[randomTrack].name;

            List<sp.TrackSimple> wrongAnswersTracks = allTracks.where((element) => !rightAnswersTracks.contains(element)).toList();
            question.wrongAnswers = setWrongAnswersTracks(wrongAnswersTracks);

            break;

          }

        case 2:
          {
            allTracksForAlbum[i].shuffle();
            List<sp.TrackSimple> wrongAnswerTracks = allTracksForAlbum[i];

            allTracks.shuffle();
            List<sp.TrackSimple> rightAnswerTracks = allTracks.where((element) => !wrongAnswerTracks.contains(element)).toList();
            int randomTrack = Random().nextInt(rightAnswerTracks.length);
            question.rightAnswer = rightAnswerTracks[randomTrack].name;

            question.wrongAnswers = setWrongAnswersTracks(wrongAnswerTracks);
            break;
          }
        case 3:
          {
            int randomTrack = Random().nextInt(allTracksForAlbum[i].length);
            sp.TrackSimple trackSelected = allTracksForAlbum[i][randomTrack];
            question.rightAnswer = trackSelected.name;

            question.url = trackSelected.previewUrl.toString();
            question.isPresent = true;

            List<sp.TrackSimple> wrongAnswerTracks = allTracksForAlbum[i].where((element) => element.name != trackSelected.name).toList();
            question.wrongAnswers = setWrongAnswersTracks(wrongAnswerTracks);

            break;
          }
      }
      questions.add(question);
      typeQuestion++;
    }
    questions.shuffle();
  }


  Future<List<sp.AlbumSimple?>> getAllAlbums(sp.Artist artist, sp.Artists artistSelected)async{
    var id = artist.id;
    List<String> input = ["album"];
    sp.Pages<sp.Album> albumsPages = artistSelected.albums(id!,includeGroups: input);
    Iterable<sp.Album> albumsLists = await albumsPages.all();
    return albumsLists.toList();
  }

  Future<List<List<sp.TrackSimple>>> getAllTracksForAlbum(List<sp.AlbumSimple?>  albums)async{
    int i = 0;
    List<List<sp.TrackSimple>> allTracksForAlbum = List.generate(albums.length, (i) => []);
    for (i = 0; i < albums.length; i++) {
      String? id = albums[i]?.id.toString();
      allTracksForAlbum[i].addAll(await sp.Albums(SpotifyService().spotify)
          .getTracks(id.toString())
          .all());
    }
    return allTracksForAlbum;
  }

  List<sp.TrackSimple> getAllTracks (List<List<sp.TrackSimple>> allTracksForAlbum){
    List<sp.TrackSimple> allTracks = [];
    int i = 0;
    for (i = 0; i < allTracksForAlbum.length; i++) {
      allTracks.addAll(allTracksForAlbum[i]);
    }
    return allTracks;
  }

  List<String> setWrongAnswersTracks (List allWrongAnswers){
    List<String> wrongAnswers = [];
    int i = 0;
    allWrongAnswers.shuffle();
    for (i = 0; i < 3; i++){
      wrongAnswers.add(allWrongAnswers[i].name);
    }
    return wrongAnswers;
  }

  List<String> setWrongAnswersYears (List allWrongAnswers){
    List<String> wrongAnswers = [];
    int i = 0;
    allWrongAnswers.shuffle();
    for (i = 0; i < 3; i++){
      wrongAnswers.add(allWrongAnswers[i]);
    }
    return wrongAnswers;
  }

}