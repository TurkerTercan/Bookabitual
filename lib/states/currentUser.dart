import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/service/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

Bookworm currentBookworm;

class CurrentUser extends ChangeNotifier {
  Bookworm currentUser = Bookworm();
  Bookworm get getCurrentUser => currentUser;

  FirebaseAuth auth;
  CurrentUser({Key key, this.auth});

  Future<String> onStartUp() async {
    String retVal = "Error";

    try {
      User _firebaseUser = auth.currentUser;
      if (_firebaseUser != null) {
        currentUser = await BookDatabase().getUserInfo(_firebaseUser.uid);
        currentBookworm = currentUser;
        if (currentUser != null) retVal = "Success";
      }
      print(currentUser.username);
    } on PlatformException catch (e) {
      retVal = e.message;
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> signOut() async {
    String retVal = "Error";

    try {
      await auth.signOut();
      currentUser = Bookworm();
      currentBookworm = currentUser;
      retVal = "Success";
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Future<String> signUpUser(
      String email, String password, String username) async {
    String retVal = "Error";
    Bookworm _user = Bookworm();

    try {
      UserCredential _authResult = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      _user.uid = _authResult.user.uid;
      _user.email = email.trim();
      _user.username = username.trim();
      _user.name = _user.username;
      _user.photoIndex = 15;
      String _returnString = await BookDatabase().createUser(_user);
      if (_returnString == "Success") {
        retVal = "Success";
      }
    } on FirebaseAuthException catch (e) {
      retVal = e.message;
      return retVal;
    } catch (e) {
      return e.toString();
    }
    return retVal;
  }

  Future<String> loginUserWithEmail(String email, String password) async {
    String retVal = "Error";
    try {
      UserCredential _authResult = await auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      currentUser = await BookDatabase().getUserInfo(_authResult.user.uid);
      currentBookworm = currentUser;
      if (currentUser != null) retVal = "Success";
    } catch (e) {
      retVal = e.message();
      return retVal;
    }
    return retVal;
  }

  Future<String> loginUserWithGoogle() async {
    String retVal = "Error";
    GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email', 'https://www.googleapis.com/auth/contacts.readonly']);

    Bookworm _user = Bookworm();

    try {
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: _googleAuth.idToken, accessToken: _googleAuth.accessToken);
      UserCredential _authResult = await auth.signInWithCredential(credential);
      if (_authResult.additionalUserInfo.isNewUser) {
        _user.uid = _authResult.user.uid;
        _user.email = _authResult.user.email;
        _user.username = _authResult.user.displayName;
        _user.name = _user.username;
        _user.photoIndex = 15;
        BookDatabase().createUser(_user);
      }
      currentUser = await BookDatabase().getUserInfo(_authResult.user.uid);
      currentBookworm = currentUser;
      if (currentUser != null) retVal = "Success";
    } catch (e) {
      retVal = e.message();
    }
    return retVal;
  }
  Future<void> saveInfo(int index , String newName) async {
    try{
      BookDatabase().setUserInfo(currentUser.uid, index, newName);
      currentUser = await BookDatabase().getUserInfo(currentUser.uid);
      currentBookworm = currentUser;
    }catch(e){
      print(e);
    }
  }
}
