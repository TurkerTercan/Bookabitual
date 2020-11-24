// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockUser extends Mock implements Bookworm {}
final MockUser _mockUser = MockUser();
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
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
