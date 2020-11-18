import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CurrentUser extends ChangeNotifier {
  Bookworm _currentUser = Bookworm();

  Bookworm get getCurrentUser => _currentUser;

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> onStartUp() async{
    String retVal = "Error";

    try{
      User _firebaseUser = _auth.currentUser;
      if (_firebaseUser != null) {
        _currentUser = await BookDatabase().getUserInfo(_firebaseUser.uid);
        if (_currentUser != null) retVal = "Success";
      }
    } on PlatformException catch(e) {
      retVal = e.message;
    } catch(e) {
      print(e);
    }

    return retVal;
  }

  Future<String> signOut() async{
    String retVal = "Error";

    try{
      await _auth.signOut();
      _currentUser = Bookworm();
      retVal = "Success";
    } catch(e) {
      print(e);
    }

    return retVal;
  }

  Future<String> signUpUser(String email, String password, String username) async {
    String retVal = "Error";
    Bookworm _user = Bookworm();

    try {
      UserCredential _authResult
        = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      _user.uid = _authResult.user.uid;
      _user.email = email;
      _user.username = username;
      String _returnString = await BookDatabase().createUser(_user);
      if (_returnString == "Success") {
        retVal = "Success";
      }
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
      _currentUser = await BookDatabase().getUserInfo(_authResult.user.uid);
      if (_currentUser != null) retVal = "Success";

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

    Bookworm _user = Bookworm();

    try {
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken,
          accessToken: _googleAuth.accessToken
      );
      UserCredential _authResult = await _auth.signInWithCredential(credential);
      if (_authResult.additionalUserInfo.isNewUser) {
        _user.uid = _authResult.user.uid;
        _user.email = _authResult.user.email;
        _user.username = _authResult.user.displayName;
        BookDatabase().createUser(_user);
      }
      _currentUser = await BookDatabase().getUserInfo(_authResult.user.uid);
      if (_currentUser != null) retVal = "Success";

    } catch(e) {
      retVal = e.message();
    }
    return retVal;
  }
}