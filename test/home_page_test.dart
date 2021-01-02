import 'dart:async';

import 'package:bookabitual/keys.dart';
import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/screens/home/feed.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class TempQuote extends QuotePost{
  var uid;
  var comments;
  var createTime;
  var likes;
  var postID;
  var status;
  var text;
  var trigger;
  var isbn;


  TempQuote({this.isbn, this.uid, this.text, this.postID, this.trigger, this.comments,
    this.createTime, this.likes, this.status
  }) : super(isbn: isbn, uid: uid, comments: comments, createTime: createTime, likes: likes,
  postID: postID, status: status, text: text, trigger: trigger);

  @override
  updateInfo() {
    user = new Bookworm(
      name: "Hello123",
      accountCreated: Timestamp.now(),
      email: "hello123@hello.com",
      photoIndex: 12,
      uid: "cBkdfmskAzc0T7xtAif8HcVNrCu2",
      username: "Hello123",
    );

    book = new Book(
      isbn: "006440501X",
      imageUrlL: "http://images.amazon.com/images/P/006440501X.01.LZZZZZZZ.jpg",
      imageUrlM: "http://images.amazon.com/images/P/006440501X.01.MZZZZZZZ.jpg",
      imageUrlS: "http://images.amazon.com/images/P/006440501X.01.THUMBZZZ.jpg",
      ratings: "3,46",
      yearOfPublication: 1994,
      publisher: "HarperTrophy",
      bookAuthor: "C. S. Lewis",
      bookTitle: "The Horse and His Boy (The Chronicles of Narnia, Book 3)"
    );
  }
}


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
}

class TempFeedPage extends FeedPage{
  @override
  FeedPageState createState() => TempFeedPageState();
}

class TempFeedPageState extends FeedPageState{
  @override
  getAllUserPost() {
    var temp = TempQuote(
        postID: "8105338f-eb03-4bce-b1f7-62c6b778febf",
        isbn: "006440501X",
        uid: "n3lxf47e8gNTER14Ms9xDnkR5Ha2",
        text: "Child said the Lion, 'I am telling you your story, not hers. No one is told any story but their own.",
        createTime: Timestamp.now(),
        status: "reading",
        likes: {},
        comments: {},
        trigger: triggerFuture);
    temp.updateInfo();
    widget.postList.add(temp);

    temp = TempQuote(
        postID: "8105338f-eb03-4bce-b1f7-62c6b778febf",
        isbn: "006440501X",
        uid: "n3lxf47e8gNTER14Ms9xDnkR5Ha2",
        text: "Child said the Lion, 'I am telling you your story, not hers. No one is told any story but their own.",
        createTime: Timestamp.now(),
        status: "reading",
        likes: {},
        comments: {},
        trigger: triggerFuture);
    temp.updateInfo();
    widget.postList.add(temp);

    Future.delayed(Duration(milliseconds: 1000));
  }
}

void main() {
  testWidgets("Feed Page Load Test", (WidgetTester tester) async {
    TempCurrentUser tempCurrentUser = TempCurrentUser();
    await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");

    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => tempCurrentUser,
      child: MaterialApp(
        home: Scaffold(body: TempFeedPage()),
      ),
    ),);
  });

  testWidgets("Create Post Button Works", (WidgetTester tester) async {
    await tester.runAsync(() async {
      final Completer completer = Completer();

      TempCurrentUser tempCurrentUser = TempCurrentUser();
      await tempCurrentUser.loginUserWithEmail("hello123@hello.com", "hello123");

      TempFeedPage feedPage;

      await tester.pumpWidget(Provider<CurrentUser>(
        create: (context) => tempCurrentUser,
        child: MaterialApp(
          home: FutureBuilder(
            future: completer.future,
            builder: (_, snapshot) {
              return Scaffold(
                body: feedPage = TempFeedPage()
              );
            }
          ),
        ),
      ),);
      
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.idle();
      await tester.pump(const Duration(seconds: 1));

      Finder createPostButton = find.byKey(Key(Keys.CreatePostButton));
      print(createPostButton);

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
    });
  });

}