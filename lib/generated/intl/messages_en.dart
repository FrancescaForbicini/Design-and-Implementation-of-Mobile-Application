// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(questionNumber) =>
      "You got ${questionNumber} questions right!";

  static String m1(level) =>
      "Press the button Continue to go to the level ${level}\nOtherwise press the button Exit\n";

  static String m2(totalScore, level) =>
      "Score: ${totalScore}   Level: ${level}";

  static String m3(score) => "You got ${score}";

  static String m4(bestScore) => "Best Score: ${bestScore}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "AuthGoogle":
            MessageLookupByLibrary.simpleMessage("Sign in with Google"),
        "AuthSignin": MessageLookupByLibrary.simpleMessage("Sign in"),
        "AuthSignup": MessageLookupByLibrary.simpleMessage("Sign up"),
        "HomeArtists": MessageLookupByLibrary.simpleMessage("Your artists:"),
        "HomeErrArtists": MessageLookupByLibrary.simpleMessage(
            "You don\'t have any favourite artist yet!"),
        "HomeErrPlaylist": MessageLookupByLibrary.simpleMessage(
            "You don\'t have any playlist yet!"),
        "HomePlaylist": MessageLookupByLibrary.simpleMessage("Your playlists:"),
        "HomeStart": MessageLookupByLibrary.simpleMessage("Start a new quiz!"),
        "HomeTitle": MessageLookupByLibrary.simpleMessage("Home Page"),
        "QuizGenExitButton": MessageLookupByLibrary.simpleMessage("Exit"),
        "QuizGenGoOnButton": MessageLookupByLibrary.simpleMessage("Continue"),
        "QuizGenNextLevel": m0,
        "QuizGenNextMessage": m1,
        "QuizGenScore": m2,
        "QuizGenTitle": MessageLookupByLibrary.simpleMessage("New Quiz"),
        "ResultButton": MessageLookupByLibrary.simpleMessage("Exit"),
        "ResultMessage": m3,
        "ResultPhoto": MessageLookupByLibrary.simpleMessage(""),
        "ResultTitle":
            MessageLookupByLibrary.simpleMessage("You missed a question!"),
        "SigninButton": MessageLookupByLibrary.simpleMessage("SIGN IN"),
        "SigninEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "SigninErr": MessageLookupByLibrary.simpleMessage("Error"),
        "SigninErrButton": MessageLookupByLibrary.simpleMessage("Ok"),
        "SigninErrText":
            MessageLookupByLibrary.simpleMessage("Invalid email or password"),
        "SigninPwd": MessageLookupByLibrary.simpleMessage("Password"),
        "SigninTitle": MessageLookupByLibrary.simpleMessage("Sign In"),
        "SignupButton": MessageLookupByLibrary.simpleMessage("SIGN UP"),
        "SignupConfirmPwd":
            MessageLookupByLibrary.simpleMessage("Confirm Password"),
        "SignupEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "SignupEmptyUser":
            MessageLookupByLibrary.simpleMessage("Username cannot be empty"),
        "SignupErrEmail": MessageLookupByLibrary.simpleMessage("Invalid Email"),
        "SignupErrMatchPwd":
            MessageLookupByLibrary.simpleMessage("The passwords do not match"),
        "SignupErrPwd": MessageLookupByLibrary.simpleMessage(
            "Password cannot be empty or shorter than 6 characters"),
        "SignupPwd": MessageLookupByLibrary.simpleMessage("Password"),
        "SignupTitle": MessageLookupByLibrary.simpleMessage("Sign Up"),
        "SignupUser": MessageLookupByLibrary.simpleMessage("Username"),
        "SpotyTitle":
            MessageLookupByLibrary.simpleMessage("Authorize access to Spotify"),
        "UserBestScore": m4,
        "UserEmail": MessageLookupByLibrary.simpleMessage("E-mail"),
        "UserQuiz": MessageLookupByLibrary.simpleMessage("My Best Quiz"),
        "UserTitle": MessageLookupByLibrary.simpleMessage("User Profile")
      };
}
