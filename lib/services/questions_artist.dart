import 'dart:core';
import 'dart:math';

import 'package:dima_project/services/questions_playlist.dart';
import 'package:dima_project/services/spotify_service.dart';
import 'package:spotify/spotify.dart' as sp;
import '../models/question.dart';


class QuestionsArtist {

  static QuestionsArtist _questionsArtist = QuestionsArtist._QuestionsArtistConstructor();

  factory QuestionsArtist() => _questionsArtist ??= QuestionsArtist._QuestionsArtistConstructor();

  QuestionsArtist._QuestionsArtistConstructor();

  List<sp.AlbumSimple?> allAlbums = [];
  List<List<sp.TrackSimple>> allTracksForAlbum = [];
  List<sp.TrackSimple> allTracks = [];
  List<String?> allYearsAlbum = [];
  List<sp.Artist>  allRelatedArtists = [];
  late int totalAlbum;

  Future<void> buildAllAnswersQuestions(sp.Artist artist)async{
    allAlbums = await getAllAlbums(artist);
    totalAlbum = allAlbums.length;
    allTracksForAlbum = await getAllTracksForAlbum(allAlbums);
    allTracks = getAllTracks(allTracksForAlbum);
    allYearsAlbum = allAlbums.map((e) => e?.releaseDate?.substring(0, 4).toString()).toList();
    if (allAlbums.length < 3){
      allRelatedArtists = await getAllRelatedArtists(artist);
      allRelatedArtists.removeRange(0, 15);
      await addYearsAlbumRelatedArtists();
    }
  }

  Future<void> addYearsAlbumRelatedArtists() async{
    for (sp.Artist artist in allRelatedArtists){
      List <sp.AlbumSimple?> allAlbumsRelatedArtist = [];
      allAlbumsRelatedArtist = await getAllAlbums(artist);
      allYearsAlbum.addAll(allAlbumsRelatedArtist.map((e) => e?.releaseDate?.substring(0, 4).toString()).toList());
    }
  }



  Future<void> buildQuestionArtists(List<Question> questions, sp.Artist artist,List questionsFromJSON) async {
    await buildAllAnswersQuestions(artist);
    if (allAlbums.length < 3){
      await buildQuestionOnRelatedArtist(questions,questionsFromJSON);

    }
    int i = 0;
    int typeQuestion = 0;
    for (i = 0; i < totalAlbum; i++) {
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


  Future<void> buildQuestionOnRelatedArtist(List<Question> questions,List questionsFromJSON) async{
    for (sp.Artist artist in  allRelatedArtists){
      buildQuestionArtists(questions, artist, questionsFromJSON);
    }
  }



  Future<List<sp.AlbumSimple?>> getAllAlbums(sp.Artist artist)async{
    sp.Artists artistsRetrieve = sp.Artists(SpotifyService().spotify);
    var id = artist.id;
    List<String> input = ["album"];
    sp.Pages<sp.Album> albumsPages = artistsRetrieve.albums(id!,includeGroups: input);
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

  Future<List<sp.Artist>> getAllRelatedArtists(sp.Artist artist)async {
    sp.Artists artistsRetrieve = sp.Artists(SpotifyService().spotify);

    var id = artist.id!;
    Iterable<sp.Artist> relatedArtists = await artistsRetrieve.getRelatedArtists(id);
    return relatedArtists.toList();
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
    int year = 0;
    int maxYear = 0;
    int minYear = 2024;
    int len = allWrongAnswers.length;
    // for (int j = 0; j < len; j++){
    //   year = int.parse(allWrongAnswers[j]);
    //
    //   if (year > maxYear) {
    //     maxYear = year;
    //   }
    //   if (year < minYear) {
    //     minYear = year;
    //   }
    //
    // }
    //
    // if (allWrongAnswers.length < 3){
    //   for (i = 0; i < 3 -len; i++){
    //     if ((maxYear + i + 1) > 2022){
    //       minYear = minYear - i -1;
    //       allWrongAnswers.add((minYear).toString());
    //     }
    //     else{
    //       maxYear = maxYear + i + 1;
    //       allWrongAnswers.add((maxYear).toString());
    //
    //     }
    //   }
    // }
    allWrongAnswers.shuffle();
    for (i = 0; i < 3; i++){
      wrongAnswers.add(allWrongAnswers[i]);
    }
    return wrongAnswers;
  }

}