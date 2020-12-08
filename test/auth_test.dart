import 'package:bookabitual/main.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

class MockUser extends Mock implements Bookworm {}
final MockUser _mockUser = MockUser();
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

Future<void> main() async{

  setUpAll(() async {
    await Firebase.initializeApp(
      name: 'test',
      options: const FirebaseOptions(
        projectId: 'bookabitual-55ad2',
        apiKey: 'AIzaSyA6t5DvLicRwfyDcImpXdJp6MHtz0w0-ZE',
        messagingSenderId: '128508211625',
        appId: '1:128508211625:android:632c13a69ad88d014c54b8',
      ),
    );
  });

  final MockFirebaseAuth mockFirebaseAuth = MockFirebaseAuth();
  final CurrentUser auth = CurrentUser();
  setUp(() {});
  tearDown(() {});

  test("emit occurs", () async {
    expectLater(auth.getCurrentUser, emitsInOrder([MockUser]));
  });

  test("sign up", () async {
    when(
        mockFirebaseAuth.createUserWithEmailAndPassword(
            email: "test@gmail.com", password: "123456"),
    ).thenAnswer((realInvocation) => null);

    expect(await auth.signUpUser("test@gmail.com", "123456", "nickname"), "Success");
  });

  test("sign up exception", () async {
    when(
      mockFirebaseAuth.createUserWithEmailAndPassword(
          email: "test@gmail.com", password: "123456"),
    ).thenAnswer((realInvocation) =>
      throw FirebaseAuthException(message: "You screwed up"));

    expect(await auth.signUpUser("test@gmail.com", "123456", "nickname"), "You screwed up");
  });

  test("sign in", () async {
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
          email: "test@gmail.com", password: "123456"),
    ).thenAnswer((realInvocation) => null);

    expect(await auth.loginUserWithEmail("test@gmail.com", "123456"), "Success");
  });

  test("sign in exception", () async {
    when(
      mockFirebaseAuth.signInWithEmailAndPassword(
          email: "test@gmail.com", password: "123456"),
    ).thenAnswer((realInvocation) =>
    throw FirebaseAuthException(message: "You screwed up"));

    expect(await auth.loginUserWithEmail("test@gmail.com", "123456"), "You screwed up");
  });

  test("sign out", () async {
    when(
      mockFirebaseAuth.signOut(),
    ).thenAnswer((realInvocation) => null);

    expect(await auth.signOut(), "Success");
  });

  test("sign out exception", () async {
    when(
      mockFirebaseAuth.signOut(),
    ).thenAnswer((realInvocation) =>
    throw FirebaseAuthException(message: "You screwed up"));

    expect(await auth.signOut(), "You screwed up");
  });

}
