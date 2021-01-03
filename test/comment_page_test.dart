
import 'package:bookabitual/keys.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mockFeedPage.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

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

    Finder commentTextField = find.byKey(Key(Keys.CommentTextField));
    expect(commentTextField, findsOneWidget);
    Finder commentPostContent = find.byKey(Key(Keys.CommentPostContent));
    expect(commentPostContent, findsOneWidget);

    await tester.enterText(commentTextField, "perfect!!!!!");

    Finder postCommentButton = find.byKey(Key(Keys.PostCommentButton));
    await tester.tap(postCommentButton);

    await tester.pump();
    await tester.pump(Duration(seconds: 3));

    commentPostContent = find.byKey(Key(Keys.CommentPostContent));
    expect(commentPostContent, findsOneWidget);

    Finder text = find.text("perfect!!!!!");
    print(text);

  });
}