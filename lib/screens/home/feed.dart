import 'dart:ui';
import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:bookabitual/widgets/reviewPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../states/currentUser.dart';
import 'localWidgets/modalBottomSheet.dart';

class FeedPage extends StatefulWidget {
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final String currentOnlineUserId = currentBookworm.uid;
  String postId = Uuid().v4();
  int countPost = 0;
  List<QuotePost> quotePosts = [];
  List<ReviewPost> reviewPosts = [];
  List<Widget> postList = [];
  Future userFuture;

  @override
  void initState() {
    userFuture = getAllPosts(currentOnlineUserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = new ScrollController();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder(
            future: userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Expanded(
                  child: Stack(
                    children: [
                      countPost == 0 ? Center(
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
                      ) : ListView.builder(
                        controller: _scrollController,
                        physics: BouncingScrollPhysics(),
                        itemCount: postList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                            margin: EdgeInsets.only(bottom: 5),
                            child: postList[index],
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
                                color: Colors.grey[700],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                ),
                                onPressed: () => onButtonPressed(
                                    context, postList, setState, _scrollController),
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
                );
              }
              else {
                return Expanded(child: Center(child: CircularProgressIndicator()));
              }
            } ,
          ),
        ],
      ),
    );
  }

  getAllPosts(String uid) async {
    QuerySnapshot queryQuoteSnapshot = await BookDatabase().getUserQuotes(uid);
    QuerySnapshot queryReviewSnapshot = await BookDatabase().getUserReviews(uid);

    countPost = queryReviewSnapshot.docs.length + queryQuoteSnapshot.docs.length;

    reviewPosts = queryReviewSnapshot.docs.map((documentSnapshot)  {
      ReviewPost reviewPost = ReviewPost(
        isbn: documentSnapshot.data()["isbn"],
        uid: documentSnapshot.data()["uid"],
        postID: documentSnapshot.data()["postID"],
        createTime: documentSnapshot.data()["createTime"],
        likes: documentSnapshot.data()["likes"],
        rating: documentSnapshot.data()["rating"],
        status: documentSnapshot.data()["status"],
        text: documentSnapshot.data()["text"],
      );
      return reviewPost;
    }).toList();

    await Future.forEach(reviewPosts, (element) async {
      await element.updateInfo();
    });

    quotePosts = queryQuoteSnapshot.docs.map((documentSnapshot) {
      QuotePost quotePost = QuotePost(
        isbn: documentSnapshot.data()["isbn"],
        uid: documentSnapshot.data()["uid"],
        postID: documentSnapshot.data()["postID"],
        createTime: documentSnapshot.data()["createTime"],
        likes: documentSnapshot.data()["likes"],
        status: documentSnapshot.data()["status"],
        text: documentSnapshot.data()["text"],
      );
      return quotePost;
    }).toList();

    await Future.forEach(quotePosts, (element) async {
      await element.updateInfo();
    });

    postList.addAll(quotePosts);
    postList.addAll(reviewPosts);

    /*setState(() {
      //countPost = queryQuoteSnapshot.docs.length;
      //quotePosts = queryQuoteSnapshot.docs.map((documentSnapshot) => QuotePost.fromDocument(documentSnapshot)).toList();
      reviewPosts = queryReviewSnapshot.docs.map((documentSnapshot)
      {
        ReviewPost temp = ReviewPost.fromDocument(documentSnapshot);
        temp.updateInfo();
        return temp;
      }).toList();
      countPost = countPost + queryReviewSnapshot.docs.length;
      countPost = queryReviewSnapshot.docs.length;
      postList.addAll(quotePosts);
      postList.addAll(reviewPosts);
    });*/
  }

  /*void _onButtonPressed(
      List<Widget> postList, StateSetter viewState, ScrollController control) {
    bool _firstChoice = true;
    bool _secondChoice = false;
    TextEditingController _author = TextEditingController();
    TextEditingController _book = TextEditingController();
    TextEditingController _rating = TextEditingController();
    TextEditingController _imageUrl = TextEditingController();
    TextEditingController _text = TextEditingController();

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.red[100],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Wrap(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(25),
                              topRight: const Radius.circular(25),
                            ),
                          ),
                          margin: EdgeInsets.only(left: 5, right: 5),
                          child: _firstChoice ? Column(
                            children: [
                              SizedBox(height: 5,),
                              Text("Create a Post",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[700],
                                ),
                              ),
                              SizedBox(height: 10,),
                              Column(
                                children: [
                                  SizedBox(height: 5,),
                                  Text("Select",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(height: MediaQuery.of(context).size.width / 20,),
                                      ButtonTheme(minWidth: MediaQuery.of(context).size.width / 3,
                                        height: 40,
                                        child: RaisedButton(
                                          color: Colors.redAccent,
                                          onPressed: () {
                                            setState(() {
                                              _firstChoice = false;
                                              _secondChoice = true;
                                            });
                                          },
                                          child: Text("Quote",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
                                        ),
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.width / 20,),
                                      ButtonTheme(
                                        minWidth: MediaQuery.of(context).size.width / 3,
                                        height: 40,
                                        child: RaisedButton(
                                          color: Colors.redAccent,
                                          onPressed: () {
                                            setState(() {
                                              _firstChoice = false;
                                              _secondChoice = false;
                                            });
                                          },
                                          child: Text("Review",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
                                        ),
                                      ),
                                      SizedBox(height: MediaQuery.of(context).size.width / 20,),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ) : Container(
                            child: _secondChoice ? Column(
                              children: [
                                SizedBox(height: 5,),
                                Text("Create a Quote",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _author,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                    Icon(Icons.person_outline),
                                    hintText: "Author",
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _book,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.book),
                                    hintText: "Book Name",
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _imageUrl,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.link),
                                    hintText: "Image URL",
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  maxLines: 5,
                                  controller: _text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.link),
                                    hintText: "Quote",
                                  ),
                                ),
                                ButtonTheme(minWidth: MediaQuery.of(context).size.width / 3,
                                  height: 40,
                                  child: RaisedButton(
                                    color: Colors.redAccent,
                                    onPressed: () {
                                      viewState(() async {
                                        QuotePost _quote = QuotePost(
                                          quoteId: postId,
                                          ownerId: Provider.of<CurrentUser>(context, listen: false).getCurrentUser.uid,
                                          username: Provider.of<CurrentUser>(context, listen: false).getCurrentUser.username,
                                          status: "Reading",
                                          userAvatarIndex: Provider.of<CurrentUser>(context, listen: false).getCurrentUser.photoIndex,
                                          quote: _text.text,
                                          likes: {},
                                          imageUrl: _imageUrl.text,
                                          createTime: Timestamp.now(),
                                          bookName: _book.text,
                                          author: _author.text,
                                        );
                                        await BookDatabase().createQuote(_quote);
                                        setState(() {
                                          postId = Uuid().v4();
                                        });
                                        control.animateTo(0.0, curve: Curves.bounceOut, duration: const Duration(milliseconds: 1000),);
                                      });
                                      Navigator.pop(context);
                                    },

                                    child: Text("Share",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
                                  ),
                                ),
                                SizedBox(height: 5,),
                              ],
                            ) : Column(
                              children: [
                                SizedBox(height: 5,),
                                Text("Create a Review",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _author,
                                  decoration: InputDecoration(
                                    prefixIcon:
                                    Icon(Icons.person_outline),
                                    hintText: "Author",
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _book,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.book),
                                    hintText: "Book Name",
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _imageUrl,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.link),
                                    hintText: "Image URL",
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  controller: _rating,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.rate_review),
                                    hintText: "Rating",
                                  ),
                                ),
                                SizedBox(height: 10,),
                                TextFormField(
                                  maxLines: 5,
                                  controller: _text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.link),
                                    hintText: "Review",
                                  ),
                                ),
                                ButtonTheme(minWidth: MediaQuery.of(context).size.width / 3,
                                  height: 40,
                                  child: RaisedButton(
                                    color: Colors.redAccent,
                                    onPressed: () {
                                      viewState(() async {
                                        ReviewPost _review = ReviewPost(
                                          reviewId: postId,
                                          ownerId: Provider.of<CurrentUser>(context, listen: false).getCurrentUser.uid,
                                          username: Provider.of<CurrentUser>(context, listen: false).getCurrentUser.username,
                                          status: "Reading",
                                          userAvatarIndex: Provider.of<CurrentUser>(context, listen: false).getCurrentUser.photoIndex,
                                          review: _text.text,
                                          likes: {},
                                          rating: double.parse(_rating.text),
                                          imageUrl: _imageUrl.text,
                                          createTime: Timestamp.now(),
                                          bookName: _book.text,
                                          author: _author.text,
                                        );
                                        await BookDatabase().createReview(_review);
                                        setState(() {
                                        postId = Uuid().v4();
                                        });
                                        control.animateTo(0.0, curve: Curves.bounceOut, duration: const Duration(milliseconds: 1000),);
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Text("Share",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0),),
                                  ),
                                ),
                                SizedBox(height: 5,),
                              ],
                            )
                          ),
                        ),
                      ],
                    );
                  }),
            ),
          );
        });
  }*/
}
