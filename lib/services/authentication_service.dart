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

  Future<bool> signUp(email, password, username, BuildContext context) async {
    var isPresent = await checkUsername(username);

    if (isPresent){
      return false;
    }

    try{
      final auth = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      //_sendVerification(auth);

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
      return false;
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> checkUsername(String username) async{
    QuerySnapshot<Map<String, dynamic>> snap = await FirebaseFirestore.instance.collection("users").where("username", isEqualTo: username).get();
    List<DocumentSnapshot> items = snap.docs.toList();

    if (items.isNotEmpty){
      print(items.first);
      return true;
    }
    return false;
  }

/*  _sendVerification(auth) async{
    await auth.currentUser?.sendEmailVerification();

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
      print("User Status: ${_isEmailVerified}");
    } catch (e) {
      // handle the error here
      print(e.toString());
    }
    _isEmailVerified = auth.currentUser!.emailVerified;

    if (_isEmailVerified) {
      _timer?.cancel();
    }
  }*/

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

    bool docExists = await checkIfDocExists(_user.email!);

    if(docExists = false) {
      FirebaseFirestore.instance.collection('users').doc(_user.email).set({
      "username": _user.displayName,
      "bestScore": 0,
      });
    }

    print("User Name: ${_user.displayName}");
    print("User Email: ${_user.email}");
  }

  signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(docId).get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<void> changeUserImage(image) async{
    var user = FirebaseAuth.instance.currentUser;

    final docRef =
    FirebaseFirestore.instance.collection("users").doc(user?.email);
    docRef.update({
      "userImage": image,
    });
  }

  Future<String?> getUserImage() async {
    var user = FirebaseAuth.instance.currentUser;
    var _data;
    var _image;

    final docRef =
    FirebaseFirestore.instance.collection("users").doc(user?.email);

    await docRef.get().then((DocumentSnapshot doc) {
      _data = doc.data() as Map<String, dynamic>;
      _image = _data["userImage"];
    });

    if(_image == null){
      return null;
    }
    return _image;
  }
}