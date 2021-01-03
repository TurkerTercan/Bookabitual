import 'dart:async';

import 'package:bookabitual/keys.dart';
import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/screens/home/feed.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:bookabitual/widgets/reviewPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'mockModalBottomSheet.dart';

class TempReview extends ReviewPost {
  var uid;
  var comments;
  var createTime;
  var likes;
  var postID;
  var status;
  var text;
  var trigger;
  var isbn;
  var rating;

  TempReview({this.isbn,
    this.uid,
    this.text,
    this.postID,
    this.trigger,
    this.comments,
    this.createTime,
    this.likes,
    this.status,
    this.rating
  }) : super(
      isbn: isbn,
      uid: uid,
      comments: comments,
      createTime: createTime,
      likes: likes,
      postID: postID,
      status: status,
      text: text,
      trigger: trigger,
      rating: rating,
  );
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
        bookTitle: "The Horse and His Boy (The Chronicles of Narnia, Book 3)");
  }
}

class TempQuote extends QuotePost {
  var uid;
  var comments;
  var createTime;
  var likes;
  var postID;
  var status;
  var text;
  var trigger;
  var isbn;

  TempQuote(
      {this.isbn,
      this.uid,
      this.text,
      this.postID,
      this.trigger,
      this.comments,
      this.createTime,
      this.likes,
      this.status})
      : super(
            isbn: isbn,
            uid: uid,
            comments: comments,
            createTime: createTime,
            likes: likes,
            postID: postID,
            status: status,
            text: text,
            trigger: trigger);

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
        bookTitle: "The Horse and His Boy (The Chronicles of Narnia, Book 3)");
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

class TempFeedPage extends FeedPage {
  @override
  FeedPageState createState() => TempFeedPageState();
}

class TempFeedPageState extends FeedPageState {
  @override
  getAllUserPost() {
    Future.delayed(Duration(milliseconds: 10));
  }

  @override
  void initState() {
    super.initState();
    var temp = TempQuote(
        postID: "8105338f-eb03-4bce-b1f7-62c6b778febf",
        isbn: "006440501X",
        uid: "n3lxf47e8gNTER14Ms9xDnkR5Ha2",
        text:
        "Child said the Lion, 'I am telling you your story, not hers. No one is told any story but their own.",
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
        text:
        "Child said the Lion, 'I am telling you your story, not hers. No one is told any story but their own.",
        createTime: Timestamp.now(),
        status: "reading",
        likes: {},
        comments: {},
        trigger: triggerFuture);
    temp.updateInfo();
    widget.postList.add(temp);
  }

  @override
  Widget build(BuildContext context) {

    ScrollController _scrollController = new ScrollController();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                widget.postList.length == 0
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ProjectContainer(
                            child: Text(
                              "There is nothing to show here. \nFollow some of your friends or share some of your favorite books!",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: widget.postList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding:
                                EdgeInsets.only(left: 10, right: 10, top: 10),
                            margin: EdgeInsets.only(bottom: 5),
                            child: widget.postList[index],
                          );
                        },
                      ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    height: 50,
                    child: FittedBox(
                      child: ButtonTheme(
                        minWidth: 100,
                        height: 40,
                        child: RaisedButton(
                          key: Key(Keys.CreatePostButton),
                          color: Colors.grey[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                          onPressed: () => onButtonPressed(
                              context,
                              widget.postList,
                              setState,
                              _scrollController,
                              triggerFuture),
                          child: Row(
                            children: [
                              Icon(Icons.add, color: Colors.grey[200]),
                              Text(
                                "Create Post",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[200],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {

  Provider.debugCheckInvalidValueType = null;

  setUp(() {
    WidgetsFlutterBinding.ensureInitialized();
  });

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

}