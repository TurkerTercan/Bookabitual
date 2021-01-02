import 'package:bookabitual/keys.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/screens/profile/profilePage.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class TempCurrentUser extends CurrentUser {
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
    currentBookworm = currentUser;
    return Future.value("Success");
  }
  @override
  Future<String> signOut() {
    currentUser = new Bookworm();
    return Future.value("Success");
  }
}

class TempProfilePage extends ProfilePage {
  @override
  TempProfilePageState createState() => TempProfilePageState();
}

class TempProfilePageState extends ProfilePageState {
  @override
  void triggerFuture() {
    setState(() {
      profileFuture = getAllPosts(currentUser.uid);
    });
  }

  @override
  getAllPosts(String uid) {
    postList.add(
      QuotePost(
          postID: "8105338f-eb03-4bce-b1f7-62c6b778febf",
          isbn: "006440501X",
          uid: "n3lxf47e8gNTER14Ms9xDnkR5Ha2",
          text: "Child said the Lion, 'I am telling you your story, not hers. No one is told any story but their own.",
          createTime: Timestamp.now(),
          status: "reading",
          likes: {},
          comments: {},
          trigger: triggerFuture)
    );
    postList.add(
        QuotePost(
            postID: "8105338f-eb03-4bce-b1f7-62c6b778febf",
            isbn: "006440501X",
            uid: "n3lxf47e8gNTER14Ms9xDnkR5Ha2",
            text: "Child said the Lion, 'I am telling you your story, not hers. No one is told any story but their own.",
            createTime: Timestamp.now(),
            status: "reading",
            likes: {},
            comments: {},
            trigger: triggerFuture)
    );
  }

  @override
  saveFuction(beforeState) {
    beforeState(() {
      currentUser.photoIndex = currentIndex;
      currentUser.name = nameController.text;
    });
  }
}


void main() {
  Provider.debugCheckInvalidValueType = null;

  testWidgets("Profile Page Load Test", (WidgetTester tester) async {
    TempCurrentUser mockCurrent = TempCurrentUser();
    await mockCurrent.loginUserWithEmail("hello123@hello.com", "hello123");

    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: Scaffold(body: TempProfilePage()),
      ),
    ),);
  });

  testWidgets("Edit button", (WidgetTester tester) async {
    TempCurrentUser mockCurrent = TempCurrentUser();
    await mockCurrent.loginUserWithEmail("hello123@hello.com", "hello123");

    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: Scaffold(body: TempProfilePage()),
      ),
    ),);
    Finder editButton = find.byKey(Key(Keys.EditButton));
    await tester.tap(editButton);
    await tester.pump();

    await tester.pump(const Duration(seconds: 1));

    expect(find.text("Change Picture"), findsOneWidget);
  });

  testWidgets("Change Avatar Test", (WidgetTester tester) async {
    TempCurrentUser mockCurrent = TempCurrentUser();
    await mockCurrent.loginUserWithEmail("hello123@hello.com", "hello123");

    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: Scaffold(body: TempProfilePage()),
      ),
    ),);

    Finder editButton = find.byKey(Key(Keys.EditButton));
    await tester.tap(editButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    Finder secondAvatar = find.byKey(Key(Keys.SecondAvatarKey));
    expect(secondAvatar, findsOneWidget);
    await tester.tap(secondAvatar);

    Finder saveButton = find.byKey(Key(Keys.SaveButton));
    await tester.tap(saveButton);

    expect(saveButton, findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    expect(mockCurrent.currentUser.photoIndex, 1);
  });


  testWidgets("Change Name Test", (WidgetTester tester) async {
    TempCurrentUser mockCurrent = TempCurrentUser();
    await mockCurrent.loginUserWithEmail("hello123@hello.com", "hello123");

    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: Scaffold(body: TempProfilePage()),
      ),
    ),);

    Finder editButton = find.byKey(Key(Keys.EditButton));
    await tester.tap(editButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    Finder usernameField = find.byKey(Key(Keys.UsernameField));
    await tester.enterText(usernameField, "test123");

    Finder saveButton = find.byKey(Key(Keys.SaveButton));
    await tester.tap(saveButton);

    expect(saveButton, findsOneWidget);

    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));


    expect(mockCurrent.currentUser.name, "test123");

  });

  testWidgets("Logout Button Test", (WidgetTester tester) async {
    TempCurrentUser mockCurrent = TempCurrentUser();
    await mockCurrent.loginUserWithEmail("hello123@hello.com", "hello123");

    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: Scaffold(body: TempProfilePage()),
      ),
    ),);

    Finder logoutButton = find.byKey(Key(Keys.LogoutButton));
    await tester.tap(logoutButton);

    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    Finder emailField = find.byKey(Key(Keys.login_email));
    expect(emailField, findsOneWidget);
  });

  testWidgets("Edit Sheet Close Test", (WidgetTester tester) async {
    TempCurrentUser mockCurrent = TempCurrentUser();
    await mockCurrent.loginUserWithEmail("hello123@hello.com", "hello123");

    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: Scaffold(body: TempProfilePage()),
      ),
    ),);

    Finder editButton = find.byKey(Key(Keys.EditButton));
    await tester.tap(editButton);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byKey(Key(Keys.SecondAvatarKey)), findsOneWidget);
    Finder usernameField = find.byKey(Key(Keys.UsernameField));
    await tester.enterText(usernameField, "test123");

    await tester.tapAt(const Offset(20.0, 20.0));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byKey(Key(Keys.LogoutButton)), findsOneWidget);
    expect(mockCurrent.currentUser.name, "Hello123");
    expect(mockCurrent.currentUser.photoIndex, 12);
  });
}