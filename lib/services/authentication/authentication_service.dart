import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthenticationService {
  bool _isEmailVerified = false;
  Timer? _timer;

  signUp(email, password, username, BuildContext context) async {
    try{
      final auth = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      _sendVerification(auth);

      FirebaseFirestore.instance.collection('User').add({
        "username": username,
        "email": email,
        "password": password,
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

    if (!_isEmailVerified) {
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        _checkVerificationStatus(auth);
      });
    }
  }

  _checkVerificationStatus(auth) async{
    try {
      await auth.currentUser!.reload();
      _isEmailVerified = auth.currentUser!.emailVerified;
    } catch (e) {
      // handle the error here
    }
    _isEmailVerified = auth.currentUser!.emailVerified;

    if (_isEmailVerified) {
      _timer?.cancel();
    }
  }

  signIn(email, password) async {
    try{
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
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
    //return await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.pop(context);
  }

  Future<void> signOut() async{
    await FirebaseAuth.instance.signOut();
  }
}