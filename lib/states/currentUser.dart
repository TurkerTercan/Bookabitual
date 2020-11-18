import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CurrentUser extends ChangeNotifier {
  String _uid;
  String _email;

  String get getUid => _uid;
  String get getEmail => _email;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> onStartUp() async{
    String retVal = "Error";

    try{
      User _firebaseUser = _auth.currentUser;
      _uid = _firebaseUser.uid;
      _email = _firebaseUser.email;
      retVal = "Success";
    } catch(e) {
      print(e);
    }

    return retVal;
  }

  Future<String> signOut() async{
    String retVal = "Error";

    try{
      await _auth.signOut();
      _uid = null;
      _email = null;
      retVal = "Success";
    } catch(e) {
      print(e);
    }

    return retVal;
  }

  Future<String> signUpUser(String email, String password) async {
    String retVal = "Error";

    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      retVal = "Success";
    } catch(e) {
      retVal = e.message();
      return retVal;
    }

    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = "Error";
    try {
      UserCredential _authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _uid = _authResult.user.uid;
      _email = _authResult.user.email;
      retVal = "Success";

    } catch(e) {
      retVal = e.message();
      return retVal;
    }
    return retVal;
  }

  Future<String> loginUserWithGoogle() async {
    String retVal = "Error";
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']
    );

    try {
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken,
          accessToken: _googleAuth.accessToken
      );
      UserCredential _authResult = await _auth.signInWithCredential(credential);
      _uid = _authResult.user.uid;
      _email = _authResult.user.email;
      retVal = "Success";

    } catch(e) {
      retVal = e.message();
    }
    return retVal;
  }
}