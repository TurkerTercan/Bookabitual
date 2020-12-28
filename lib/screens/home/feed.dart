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

  final GlobalKey<RefreshIndicatorState> _globalKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    userFuture = getAllUserPost();
    super.initState();
  }

  void triggerFuture() {
    setState(() {
      userFuture = getAllUserPost();
    });
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
                      postList.length == 0 ? Center(
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
                      ) : RefreshIndicator(
                        key: _globalKey,
                        onRefresh: () {
                          return Future.delayed(Duration(milliseconds: 50)).then((value) => {
                            setState(() {
                              userFuture = getAllUserPost();
                            })
                          });
                        },
                        child: ListView.builder(
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
                                    context, postList, setState, _scrollController, triggerFuture),
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

  getAllUserPost() async {
    postList.clear();
    var temp = await FirebaseFirestore.instance.collection("Posts").get();
    List unsorted = [];
    await Future.forEach(temp.docs, (element) async {
      QuerySnapshot queryQuoteSnapshot = await BookDatabase().getUserQuotes(element.id);
      QuerySnapshot queryReviewSnapshot = await BookDatabase().getUserReviews(element.id);
      countPost += queryReviewSnapshot.docs.length + queryQuoteSnapshot.docs.length;

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
          comments: documentSnapshot.data()["comments"],
          trigger: triggerFuture,
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
          comments: documentSnapshot.data()["comments"],
          trigger: triggerFuture,
        );
        return quotePost;
      }).toList();

      await Future.forEach(quotePosts, (element) async {
        await element.updateInfo();
      });

      unsorted.addAll(quotePosts);
      unsorted.addAll(reviewPosts);
    });
    unsorted.sort((a, b) {
      Timestamp x = a.createTime;
      Timestamp y = b.createTime;
      return y.compareTo(x);
    });
    unsorted.forEach((element) {
      postList.add(element);
    });
  }


}
