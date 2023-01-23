// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a it locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'it';

  static String m0(score) => "Miglior punteggio: ${score}";

  static String m1(questionNumber) =>
      "Hai risposto correttamente a ${questionNumber} domande!";

  static String m2(level) =>
      "Premi il pulsante Continua per procedere al livello ${level}\nAltrimenti premi il pulsante Esci\n";

  static String m3(totalScore, level) =>
      "Punteggio: ${totalScore}   Livello: ${level}";

  static String m4(score) => "Punteggio: ${score}";

  static String m5(bestScore) => "Miglior punteggio: ${bestScore}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AuthGoogle": MessageLookupByLibrary.simpleMessage("Accedi con Google"),
        "AuthSignin": MessageLookupByLibrary.simpleMessage("Accedi"),
        "AuthSignup": MessageLookupByLibrary.simpleMessage("Registrati"),
        "BestQuizScore":
            MessageLookupByLibrary.simpleMessage("Il tuo miglior risultato è "),
        "BestQuizTitle":
            MessageLookupByLibrary.simpleMessage("Il Mio Miglior Quiz"),
        "GlobalBestScore": m0,
        "GlobalErr":
            MessageLookupByLibrary.simpleMessage("Non ci sono giocatori!"),
        "GlobalLocation": MessageLookupByLibrary.simpleMessage("Paese"),
        "GlobalPosition": MessageLookupByLibrary.simpleMessage("Posizione"),
        "GlobalScore": MessageLookupByLibrary.simpleMessage("Punteggio"),
        "GlobalTitle":
            MessageLookupByLibrary.simpleMessage("Classifica Globale"),
        "GlobalUsername": MessageLookupByLibrary.simpleMessage("Username"),
        "HomeArtists": MessageLookupByLibrary.simpleMessage("I tuoi artisti:"),
        "HomeErrArtists": MessageLookupByLibrary.simpleMessage(
            "Non hai ancora nessun artista preferito!"),
        "HomeErrPlaylist": MessageLookupByLibrary.simpleMessage(
            "Non hai ancora nessuna playlist!"),
        "HomePlaylist":
            MessageLookupByLibrary.simpleMessage("Le tue playlists:"),
        "HomeStart":
            MessageLookupByLibrary.simpleMessage("Comincia un nuovo quiz!"),
        "HomeTitle": MessageLookupByLibrary.simpleMessage("La tua Home Page"),
        "NoQuizPresent": MessageLookupByLibrary.simpleMessage(
            "Non hai ancora finito nessun quiz!"),
        "PositionDenied": MessageLookupByLibrary.simpleMessage(
            "I permessi di localizzazione sono stati negati"),
        "PositionDisabled": MessageLookupByLibrary.simpleMessage(
            "La Localizzazione è disattivata. Per favore, attivala"),
        "PositionError": MessageLookupByLibrary.simpleMessage("Errore"),
        "PositionSuperDenied": MessageLookupByLibrary.simpleMessage(
            "Permessi di localizzazione negati permanentemente, non è possibile richiedere i permessi"),
        "QuestionArtist11": MessageLookupByLibrary.simpleMessage(
            "Quando è stato rilasciato l\'album "),
        "QuestionArtist12": MessageLookupByLibrary.simpleMessage("?"),
        "QuestionArtist21": MessageLookupByLibrary.simpleMessage(
            "Quale canzone è presente nell\'album "),
        "QuestionArtist22": MessageLookupByLibrary.simpleMessage("?"),
        "QuestionArtist31": MessageLookupByLibrary.simpleMessage(
            "Quale canzone NON è nell\'album "),
        "QuestionArtist32": MessageLookupByLibrary.simpleMessage("?"),
        "QuestionArtist41":
            MessageLookupByLibrary.simpleMessage("Che canzone è"),
        "QuestionArtist42": MessageLookupByLibrary.simpleMessage("?"),
        "QuestionPlaylist11":
            MessageLookupByLibrary.simpleMessage("Chi ha rilasciato "),
        "QuestionPlaylist12": MessageLookupByLibrary.simpleMessage("?"),
        "QuestionPlaylist21":
            MessageLookupByLibrary.simpleMessage("Quale album contiene "),
        "QuestionPlaylist22": MessageLookupByLibrary.simpleMessage("?"),
        "QuestionPlaylist31":
            MessageLookupByLibrary.simpleMessage("Che canzone è"),
        "QuestionPlaylist32": MessageLookupByLibrary.simpleMessage("?"),
        "QuizGenExitButton": MessageLookupByLibrary.simpleMessage("Esci"),
        "QuizGenGoOnButton": MessageLookupByLibrary.simpleMessage("Continua"),
        "QuizGenNextLevel": m1,
        "QuizGenNextMessage": m2,
        "QuizGenScore": m3,
        "QuizGenTitle": MessageLookupByLibrary.simpleMessage("Nuovo quiz"),
        "ResultButton": MessageLookupByLibrary.simpleMessage("Esci"),
        "ResultMessage": m4,
        "ResultPicture":
            MessageLookupByLibrary.simpleMessage("Salva una Foto del Quiz"),
        "ResultPosition":
            MessageLookupByLibrary.simpleMessage("Salva la Posizione del Quiz"),
        "ResultTitle":
            MessageLookupByLibrary.simpleMessage("Hai commesso un errore!"),
        "SigninButton": MessageLookupByLibrary.simpleMessage("ACCEDI"),
        "SigninEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "SigninErr": MessageLookupByLibrary.simpleMessage("Errore"),
        "SigninErrButton": MessageLookupByLibrary.simpleMessage("Ok"),
        "SigninErrText": MessageLookupByLibrary.simpleMessage(
            "Email o password non corrette"),
        "SigninPwd": MessageLookupByLibrary.simpleMessage("Password"),
        "SigninTitle": MessageLookupByLibrary.simpleMessage("Accedi"),
        "SignupButton": MessageLookupByLibrary.simpleMessage("REGISTRATI"),
        "SignupConfirmPwd":
            MessageLookupByLibrary.simpleMessage("Conferma password"),
        "SignupEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "SignupEmptyUser": MessageLookupByLibrary.simpleMessage(
            "Lo username non può essere vuoto"),
        "SignupErrEmail":
            MessageLookupByLibrary.simpleMessage("Email non valida"),
        "SignupErrMatchPwd": MessageLookupByLibrary.simpleMessage(
            "Le password non corrispondono"),
        "SignupErrPwd": MessageLookupByLibrary.simpleMessage(
            "La password non può essere vuota o più corta di 6 caratteri"),
        "SignupFail":
            MessageLookupByLibrary.simpleMessage("Registrazione fallita!"),
        "SignupFailButton": MessageLookupByLibrary.simpleMessage("Ok"),
        "SignupFailText": MessageLookupByLibrary.simpleMessage(
            "Username scelto già presente, cambia username"),
        "SignupOk":
            MessageLookupByLibrary.simpleMessage("Registrazione completata!"),
        "SignupOkButton": MessageLookupByLibrary.simpleMessage("Ok"),
        "SignupOkText": MessageLookupByLibrary.simpleMessage(
            "Ora puoi effettuare il login"),
        "SignupPwd": MessageLookupByLibrary.simpleMessage("Password"),
        "SignupTitle": MessageLookupByLibrary.simpleMessage("Registrati"),
        "SignupUser": MessageLookupByLibrary.simpleMessage("Username"),
        "SpotyTitle":
            MessageLookupByLibrary.simpleMessage("Autorizza accesso a Spotify"),
        "UserBestScore": m5,
        "UserEmail": MessageLookupByLibrary.simpleMessage("E-mail"),
        "UserQuiz": MessageLookupByLibrary.simpleMessage("Il mio miglior Quiz"),
        "UserRank": MessageLookupByLibrary.simpleMessage("Classifica"),
        "UserTitle": MessageLookupByLibrary.simpleMessage("Profilo Utente")
      };
}
