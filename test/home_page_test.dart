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

  testWidgets('OnDoubleClick event on content, BookPage opens', (WidgetTester tester) async {
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

    Finder content = find.byKey(Key(Keys.BookButton));
    GestureDetector gesture = content.first.evaluate().single.widget as GestureDetector;
    gesture.onDoubleTap.call();

    await tester.pump();
    await tester.pump(Duration(seconds: 1));


    Finder bookTitle = find.byKey(Key(Keys.BookTitle));
    expect(bookTitle, findsOneWidget);
  });

  testWidgets('OnClick event on CircleAvatar, AnotherProfile opens', (WidgetTester tester) async {
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

    Finder userAvatar = find.byKey(Key(Keys.AvatarButton));
    GestureDetector gesture = userAvatar.last.evaluate().single.widget as GestureDetector;
    gesture.onTap.call();

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder anotherProfileUsername = find.byKey(Key(Keys.AnotherProfileUsername));
    expect(anotherProfileUsername, findsOneWidget);
  });

  testWidgets('OnClick event on View All Comments, CommentPage opens', (WidgetTester tester) async {
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

    Finder commentButton = find.byKey(Key(Keys.CommentButton));
    GestureDetector gesture = commentButton.first.evaluate().single.widget as GestureDetector;
    gesture.onTap.call();

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder commentPostContent = find.byKey(Key(Keys.CommentPostContent));
    expect(commentPostContent, findsOneWidget);
  });

  testWidgets('OnClick event on View All Comments, CommentPage opens and return it', (WidgetTester tester) async {
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

    Finder commentButton = find.byKey(Key(Keys.CommentButton));
    GestureDetector gesture = commentButton.first.evaluate().single.widget as GestureDetector;
    gesture.onTap.call();

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder commentPostContent = find.byKey(Key(Keys.CommentPostContent));
    commentButton = find.byKey(Key(Keys.CommentButton));
    expect(commentPostContent, findsOneWidget);
    expect(commentButton, findsNothing);

    await tester.pageBack();

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    commentButton = find.byKey(Key(Keys.CommentButton));
    expect(commentButton, findsWidgets);
  });
}