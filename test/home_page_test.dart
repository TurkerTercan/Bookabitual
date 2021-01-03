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

  testWidgets("Like Button Test", (WidgetTester tester) async {
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

    Finder likeButton = find.byKey(Key(Keys.LikeButton));
    await tester.tap(likeButton.first);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.text("1 likes"), findsOneWidget);
  });

  testWidgets("UnLike Button Test", (WidgetTester tester) async {
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

    Finder likeButton = find.byKey(Key(Keys.LikeButton));
    await tester.tap(likeButton.first);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.text("1 likes"), findsOneWidget);

    await tester.tap(likeButton.first);
    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(find.text("0 likes").first, findsOneWidget);
  });


  testWidgets("Delete Post Dialog Test - Yes", (WidgetTester tester) async {
    TempCurrentUser tempCurrentUser = TempCurrentUser();
    await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");
    TempFeedPage page;
    await tester.pumpWidget(
      Provider<CurrentUser>(
        create: (context) => tempCurrentUser,
        child: MaterialApp(
          home: Scaffold(body: page = TempFeedPage()),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder vertIcon = find.byKey(Key(Keys.VertIcon));
    await tester.tap(vertIcon);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder yesButton = find.byKey(Key(Keys.YesButton));
    await tester.tap(yesButton);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(page.postList.length, 1);
  });

  testWidgets("Delete Post Dialog Test - No", (WidgetTester tester) async {
    TempCurrentUser tempCurrentUser = TempCurrentUser();
    await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");
    TempFeedPage page;
    await tester.pumpWidget(
      Provider<CurrentUser>(
        create: (context) => tempCurrentUser,
        child: MaterialApp(
          home: Scaffold(body: page = TempFeedPage()),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder vertIcon = find.byKey(Key(Keys.VertIcon));
    await tester.tap(vertIcon);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder noButton = find.byKey(Key(Keys.NoButton));
    await tester.tap(noButton);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(page.postList.length, 2);
  });
}