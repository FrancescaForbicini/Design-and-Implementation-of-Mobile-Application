import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  static AuthenticationService _authenticationService = AuthenticationService._AuthenticationServiceConstructor();

  bool _isEmailVerified = false;
  late User _user;
  Timer? _timer;

  factory AuthenticationService() => _authenticationService ??= AuthenticationService._AuthenticationServiceConstructor();

  AuthenticationService._AuthenticationServiceConstructor();

  signUp(email, password, username, BuildContext context) async {
    try{
      final auth = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      _sendVerification(auth);

      FirebaseFirestore.instance.collection('users').doc(email).set({
        "username": username,
        "bestScore": 0,
      });
      print("Everything went well!");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
    Navigator.pop(context);
  }

  _sendVerification(auth) async{
    await auth.user?.sendEmailVerification();

/*    if (!_isEmailVerified) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        _checkVerificationStatus(auth);
      });
    }*/
  }

  _checkVerificationStatus(auth) async{
    try {
      await auth.user!.reload();
      _isEmailVerified = auth.user!.emailVerified;
      print("User Status: ${_isEmailVerified}");
    } catch (e) {
      // handle the error here
      print(e.toString());
    }
    _isEmailVerified = auth.user!.emailVerified;

    if (_isEmailVerified) {
      _timer?.cancel();
    }
  }

  Future<bool> signIn(email, password) async {
    try{
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    }
  }

  signInWithGoogle(BuildContext context) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    UserCredential result = await FirebaseAuth.instance.signInWithCredential(credential);

    _user = result.user!;

    FirebaseFirestore.instance.collection('users').doc(_user.email).set({
      "username": _user.displayName,
      "bestScore": 0,
    });

    print("User Name: ${_user.displayName}");
    print("User Email ${_user.email}");
  }

  signOut() async{
    await FirebaseAuth.instance.signOut();
  }
}