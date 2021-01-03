
import 'package:bookabitual/keys.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'mockFeedPage.dart';


void main() {

  Provider.debugCheckInvalidValueType = null;

  testWidgets("Feed Page Load Test", (WidgetTester tester) async {
    TempCurrentUser tempCurrentUser = TempCurrentUser();
    await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");

    await tester.pumpWidget(
      Provider<CurrentUser>(
        create: (context) => tempCurrentUser,
        child: MaterialApp(
          home: Scaffold(body: TempFeedPage()),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(Duration(seconds: 1));
  });

  testWidgets("Modal bottom sheet opens correctly", (WidgetTester tester) async {
    TempCurrentUser tempCurrentUser = TempCurrentUser();
    await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");

    TempFeedPage feed;
    await tester.pumpWidget(
      Provider<CurrentUser>(
        create: (context) => tempCurrentUser,
        child: MaterialApp(
          home: Scaffold(body: feed = TempFeedPage()),
        ),
      ),
    );

    await tester.pump();

    Finder createPostButton = find.byKey(Key(Keys.CreatePostButton));
    await tester.tap(createPostButton);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder booknameField = find.byKey(Key(Keys.BooknameField));
    expect(booknameField, findsOneWidget);
  });

  testWidgets("Create Quote Post", (WidgetTester tester) async {
    TempCurrentUser tempCurrentUser = TempCurrentUser();
    await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");

    TempFeedPage feed;
    await tester.pumpWidget(
      Provider<CurrentUser>(
        create: (context) => tempCurrentUser,
        child: MaterialApp(
          home: Scaffold(body: feed = TempFeedPage()),
        ),
      ),
    );

    await tester.pump();

    Finder createPostButton = find.byKey(Key(Keys.CreatePostButton));
    await tester.tap(createPostButton);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder booknameField = find.byKey(Key(Keys.BooknameField));
    await tester.enterText(booknameField, "441172717");

    Finder contentField = find.byKey(Key(Keys.ContentField));
    await tester.enterText(contentField, "I must not fear. Fear is the mind-killer.");

    Finder createPostButton2 = find.byKey(Key(Keys.CreatePostButton2));
    await tester.tap(createPostButton2);

    await tester.pump();
    await tester.pump(Duration(seconds: 2));

    expect(feed.postList.length, 3);
  });

  testWidgets("Create Review Post", (WidgetTester tester) async {
    TempCurrentUser tempCurrentUser = TempCurrentUser();
    await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");

    TempFeedPage feed;
    await tester.pumpWidget(
      Provider<CurrentUser>(
        create: (context) => tempCurrentUser,
        child: MaterialApp(
          home: Scaffold(body: feed = TempFeedPage()),
        ),
      ),
    );

    await tester.pump();

    Finder createPostButton = find.byKey(Key(Keys.CreatePostButton));
    await tester.tap(createPostButton);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder categoryButton = find.byKey(Key(Keys.CategoryDropButton));
    await tester.tap(categoryButton);

    await tester.pump();
    await tester.pump(Duration(seconds: 2));

    Finder reviewButton = find.byKey(Key(Keys.ReviewChoice));
    print(reviewButton);
    await tester.tap(reviewButton.at(1));

    await tester.pump();
    await tester.pump(Duration(seconds: 2));

    Finder booknameField = find.byKey(Key(Keys.BooknameField));
    await tester.enterText(booknameField, "441172717");

    Finder contentField = find.byKey(Key(Keys.ContentField));
    await tester.enterText(contentField, "I must not fear. Fear is the mind-killer.");

    Finder ratingButton = find.byKey(Key(Keys.RatingDropButton));
    expect(ratingButton, findsOneWidget);

    Finder createPostButton2 = find.byKey(Key(Keys.CreatePostButton2));
    print(createPostButton2);
    await tester.tap(createPostButton2);

    await tester.pump();
    await tester.pump(Duration(seconds: 2));

    expect(feed.postList.length, 3);
  });

  testWidgets("Create Quote Post -- create post button is not tapped", (WidgetTester tester) async {
    TempCurrentUser tempCurrentUser = TempCurrentUser();
    await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");

    TempFeedPage feed;
    await tester.pumpWidget(
      Provider<CurrentUser>(
        create: (context) => tempCurrentUser,
        child: MaterialApp(
          home: Scaffold(body: feed = TempFeedPage()),
        ),
      ),
    );

    await tester.pump();

    Finder createPostButton = find.byKey(Key(Keys.CreatePostButton));
    await tester.tap(createPostButton);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder booknameField = find.byKey(Key(Keys.BooknameField));
    await tester.enterText(booknameField, "441172717");

    Finder contentField = find.byKey(Key(Keys.ContentField));
    await tester.enterText(contentField, "I must not fear. Fear is the mind-killer.");

    await tester.tapAt(const Offset(20.0, 20.0));

    await tester.pump();
    await tester.pump(Duration(seconds: 2));

    expect(feed.postList.length, 2);
  });

  testWidgets("Create Quote Post -- Content is empty", (WidgetTester tester) async {
    TempCurrentUser tempCurrentUser = TempCurrentUser();
    await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");

    TempFeedPage feed;
    await tester.pumpWidget(
      Provider<CurrentUser>(
        create: (context) => tempCurrentUser,
        child: MaterialApp(
          home: Scaffold(body: feed = TempFeedPage()),
        ),
      ),
    );

    await tester.pump();

    Finder createPostButton = find.byKey(Key(Keys.CreatePostButton));
    await tester.tap(createPostButton);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder booknameField = find.byKey(Key(Keys.BooknameField));
    await tester.enterText(booknameField, "441172717");


    Finder createPostButton2 = find.byKey(Key(Keys.CreatePostButton2));
    await tester.tap(createPostButton2);

    await tester.pump();
    await tester.pump(Duration(seconds: 2));

    expect(feed.postList.length, 2);
  });


}
