import 'package:bookabitual/states/currentUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth{}


void main() async {
  setUpAll(() {});
  tearDown(() {});

  final MockFirebaseAuth mockAuth = MockFirebaseAuth();
  final CurrentUser currentUser = CurrentUser(auth: FirebaseAuth.instance);

  test("create account", () async {
    when(
      mockAuth.createUserWithEmailAndPassword(email: "dummy@dummy.com", password: "dummy1"),
    ).thenAnswer((realInvocation) => null);
    expect(await currentUser.signUpUser("dummy@dummy.com", "dummy1", "dummy"), "Success");
  });


}