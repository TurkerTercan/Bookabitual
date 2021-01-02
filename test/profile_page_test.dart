import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/screens/profile/profilePage.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockCurrentUser extends Mock implements CurrentUser {
  @override
  Future<String> loginUserWithEmail(String email, String password) {
    currentUser = new Bookworm(
      name: "Hello123",
      accountCreated: Timestamp.now(),
      email: "hello123@hello.com",
      photoIndex: 12,
      uid: "cBkdfmskAzc0T7xtAif8HcVNrCu2",
      username: "Hello123",
    );
    print(currentUser.uid);
    currentBookworm = currentUser;
    return Future.value("Success");
  }
}

void main() {

  testWidgets("Profile Page Load Test", (WidgetTester tester) async {
    MockCurrentUser mockCurrent = MockCurrentUser();
    await mockCurrent.loginUserWithEmail("hello123@hello.com", "hello123");
    print(mockCurrent.currentUser.uid);

    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: ProfilePage(),
      ),
    ),);
  });
}