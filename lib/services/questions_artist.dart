import 'dart:core';
import 'dart:math';
import 'package:dima_project/services/spotify_service.dart';
import 'package:flutter/material.dart';
import 'package:spotify/spotify.dart' as sp;
import '../generated/l10n.dart';
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
  bool relatedArtist = false;

  Future<void> buildAllAnswersQuestions(sp.Artist artist)async{
    allAlbums = await getAllAlbums(artist);
    allTracksForAlbum = await getAllTracksForAlbum(allAlbums);
    allTracks = getAllTracks();
    allYearsAlbum = getAllYearsAlbum(artist);
  }

  Future<void> buildQuestionArtists(List<Question> questions, sp.Artist artist, List questionsFromJSON) async {
    allAlbums = await getAllAlbums(artist);
    if (allAlbums.length < 4){
      relatedArtist = true;
      allRelatedArtists = await getAllRelatedArtists(artist);
      // keep the first 5 artist similar to the current one
      allRelatedArtists.removeRange(5, allRelatedArtists.length);
      for (sp.Artist relatedArtist in allRelatedArtists){
        await buildAllAnswersQuestions(relatedArtist);
        await buildQuestions(questions, relatedArtist, questionsFromJSON);
      }
    }

    await buildAllAnswersQuestions(artist);
    await buildQuestions(questions,artist,questionsFromJSON);
  }

  Future<void> buildQuestions(List<Question> questions, sp.Artist artist, List questionsFromJSON) async {
    int i = 0;
    int typeQuestion;
    relatedArtist ? typeQuestion = 1 : typeQuestion = 0;
    for (i = 0; i < allAlbums.length; i++) {
      Question question = Question();

      if (typeQuestion > 3) {
        relatedArtist ? typeQuestion = 1 : typeQuestion = 0;
      }

/*      question.question1 = questionsFromJSON[typeQuestion]["question1"];
      question.question2 = questionsFromJSON[typeQuestion]["question2"];*/
      question.artistAlbum = allAlbums[i]?.name;

      switch (typeQuestion) {
        case 0:
          {
            question.question1 = S.current.QuestionArtist11;
            question.question2 = S.current.QuestionArtist12;
            String? yearSelected = allAlbums[i]?.releaseDate?.substring(0, 4).toString();
            question.rightAnswer = yearSelected;

            List<String?> wrongYears = allYearsAlbum.where((element) => element != yearSelected).toList();
            question.wrongAnswers = setWrongAnswersYears(wrongYears);

            break;
          }
        case 1:
          {
            question.question1 = S.current.QuestionArtist21;
            question.question2 = S.current.QuestionArtist22;
            List<sp.TrackSimple> rightAnswersTracks = allTracksForAlbum[i];
            allTracks.shuffle();

            int randomTrack = Random().nextInt(rightAnswersTracks.length);
            question.rightAnswer = rightAnswersTracks[randomTrack].name;

            List<sp.TrackSimple> wrongAnswersTracks = allTracks.where((element) => element != rightAnswersTracks[randomTrack]).toList();
            question.wrongAnswers = setWrongAnswersTracks(wrongAnswersTracks);
            questions.add(question);

            break;

          }

        case 2:
          {
            question.question1 = S.current.QuestionArtist31;
            question.question2 = S.current.QuestionArtist32;
            allTracksForAlbum[i].shuffle();
            List<sp.TrackSimple> wrongAnswerTracks = allTracksForAlbum[i];

            allTracks.shuffle();
            List<sp.TrackSimple> rightAnswerTracks = allTracks.where((element) => !wrongAnswerTracks.contains(element)).toList();
            int randomTrack = Random().nextInt(rightAnswerTracks.length);
            question.rightAnswer = rightAnswerTracks[randomTrack].name;

            question.wrongAnswers = setWrongAnswersTracks(wrongAnswerTracks);
            questions.add(question);

            break;
          }
        case 3:
          {
            question.question1 = S.current.QuestionArtist41;
            question.question2 = S.current.QuestionArtist42;
            // takes random number of tracks in the album
            int randomNumber = Random().nextInt(allTracksForAlbum[i].length);
            int j = 0;
            allTracksForAlbum[i].shuffle;
            for (j = 0; j < randomNumber; j++){

              Question questionTrack = Question();
              questionTrack.question1 = question.question1;
              questionTrack.question2 = question.question2;

              int randomTrack = Random().nextInt(allTracksForAlbum[i].length);
              sp.TrackSimple trackSelected = allTracksForAlbum[i][randomTrack];
              questionTrack.rightAnswer = trackSelected.name;

              question.url = trackSelected.previewUrl.toString();
              questionTrack.isPresent = true;

              List<sp.TrackSimple> wrongAnswerTracks = allTracks.where((element) => element.name != trackSelected.name).toList();
              questionTrack.wrongAnswers = setWrongAnswersTracks(wrongAnswerTracks);
              questions.add(questionTrack);
            }

            break;
          }
      }
      typeQuestion++;
    }

    questions.shuffle();
  }

  void addQuestionsOnTracks(questions){

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
    List<List<sp.TrackSimple>> allTracksForAlbum = List.generate(allAlbums.length, (i) => []);
    for (i = 0; i < allAlbums.length; i++) {
      String? id = albums[i]?.id.toString();
      allTracksForAlbum[i].addAll(await sp.Albums(SpotifyService().spotify)
          .getTracks(id.toString())
          .all());
    }
    return allTracksForAlbum;
  }

  List<sp.TrackSimple> getAllTracks (){
    List<sp.TrackSimple> allTracks = [];
    int i = 0;
    for (i = 0; i < allTracksForAlbum.length; i++) {
      allTracks.addAll(allTracksForAlbum[i]);
    }
    return allTracks;
  }

  List<String?> getAllYearsAlbum (artist){
    List<String?> allYears = [];
    allYears = allAlbums.map((e) => e?.releaseDate?.substring(0, 4).toString()).toList();
    for (String? year in allYears) {
      if (!allYearsAlbum.contains(year.toString())) {
        allYearsAlbum.add(year!);
      }
    }
    return allYears;
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
    int i;
    allWrongAnswers.shuffle();
    for (i = 0; i < 3; i++){
      wrongAnswers.add(allWrongAnswers[i]);
    }
    return wrongAnswers;
  }

}