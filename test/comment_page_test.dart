
import 'package:bookabitual/keys.dart';
import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'mockFeedPage.dart';
import 'mockQuoteComment.dart';

void main() {
  Provider.debugCheckInvalidValueType = null;

  testWidgets('CommentPage opens and creates a comment', (WidgetTester tester) async {
    TempCurrentUser tempCurrentUser = TempCurrentUser();
    await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");
    MockQuoteComment page;
    await tester.pumpWidget(
      Provider<CurrentUser>(
        create: (context) => tempCurrentUser,
        child: MaterialApp(
          home: Scaffold(body: page = MockQuoteComment(
            user: Bookworm(
              name: "Hello123",
              accountCreated: Timestamp.now(),
              email: "hello123@hello.com",
              photoIndex: 12,
              uid: "cBkdfmskAzc0T7xtAif8HcVNrCu2",
              username: "Hello123",
            ),
            book: Book(
                isbn: "006440501X",
                imageUrlL:
                "http://images.amazon.com/images/P/006440501X.01.LZZZZZZZ.jpg",
                imageUrlM:
                "http://images.amazon.com/images/P/006440501X.01.MZZZZZZZ.jpg",
                imageUrlS:
                "http://images.amazon.com/images/P/006440501X.01.THUMBZZZ.jpg",
                ratings: "3,46",
                yearOfPublication: 1994,
                publisher: "HarperTrophy",
                bookAuthor: "C. S. Lewis",
                bookTitle: "The Horse and His Boy (The Chronicles of Narnia, Book 3)"),
            comments: {
              "n3lxf47e8gNTER14Ms9xDnkR5Ha2" : {
                "ahahahhahahahahahahahah" : Timestamp.now()
              }
            },
            postID: "wrjwer2io342o3p",
            createTime: Timestamp.now(),
            text: "ne hoj bir kitabtir",
          )),
        ),
      ),
    );

    expect(page.commentWidgets.length, 2);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder commentPostContent = find.byKey(Key(Keys.CommentPostContent));
    expect(commentPostContent, findsOneWidget);

    Finder commentTextField = find.byKey(Key(Keys.CommentTextField));
    expect(commentTextField, findsOneWidget);

    await tester.enterText(commentTextField, "perfect!!");

    Finder postCommentButton = find.byKey(Key(Keys.PostCommentButton));
    await tester.tap(postCommentButton);

    expect(page.commentWidgets.length, 3);
  });

  testWidgets('CommentPage opens and removes a comment', (WidgetTester tester) async {
    TempCurrentUser tempCurrentUser = TempCurrentUser();
    await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");
    MockQuoteComment page;
    await tester.pumpWidget(
      Provider<CurrentUser>(
        create: (context) => tempCurrentUser,
        child: MaterialApp(
          home: Scaffold(body: page = MockQuoteComment(
            user: Bookworm(
              name: "Hello123",
              accountCreated: Timestamp.now(),
              email: "hello123@hello.com",
              photoIndex: 12,
              uid: "cBkdfmskAzc0T7xtAif8HcVNrCu2",
              username: "Hello123",
            ),
            book: Book(
                isbn: "006440501X",
                imageUrlL:
                "http://images.amazon.com/images/P/006440501X.01.LZZZZZZZ.jpg",
                imageUrlM:
                "http://images.amazon.com/images/P/006440501X.01.MZZZZZZZ.jpg",
                imageUrlS:
                "http://images.amazon.com/images/P/006440501X.01.THUMBZZZ.jpg",
                ratings: "3,46",
                yearOfPublication: 1994,
                publisher: "HarperTrophy",
                bookAuthor: "C. S. Lewis",
                bookTitle: "The Horse and His Boy (The Chronicles of Narnia, Book 3)"),
            comments: {
              "n3lxf47e8gNTER14Ms9xDnkR5Ha2" : {
                "ahahahhahahahahahahahah" : Timestamp.now()
              }
            },
            postID: "wrjwer2io342o3p",
            createTime: Timestamp.now(),
            text: "ne hoj bir kitabtir",
          )),
        ),
      ),
    );

    expect(page.commentWidgets.length, 2);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    Finder commentPostContent = find.byKey(Key(Keys.CommentPostContent));
    expect(commentPostContent, findsOneWidget);

    Finder deleteButton = find.byKey(Key(Keys.DeleteCommentButton));
    expect(deleteButton, findsOneWidget);

    await tester.tap(deleteButton);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));


    Finder yesButton = find.byKey(Key(Keys.YesButton));
    expect(yesButton, findsOneWidget);
    await tester.tap(yesButton);

    await tester.pump();
    await tester.pump(Duration(seconds: 1));

    expect(page.commentWidgets.length, 1);
  });


}