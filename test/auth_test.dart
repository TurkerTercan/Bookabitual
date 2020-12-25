import 'package:bookabitual/states/currentUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();

void main() async {
  setupFirebaseAuthMocks();
  FirebaseAuth auth;


  group("$FirebaseAuth", () {
    setUpAll(() async{
      await Firebase.initializeApp();
      auth = FirebaseAuth.instance;

      auth.createUserWithEmailAndPassword(email: "test@test.com", password: "test1234");
    });
  });

}

/*void main() async {

  test("test", () async {
    final googleSignIn = MockGoogleSignIn();
    final signinAccount = await googleSignIn.signIn();
    final googleAuth = await signinAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final auth = MockFirebaseAuth();
    final result = await auth.signInWithCredential(credential);
    final user = await result.user;
    print(user.displayName);
  });

}*/