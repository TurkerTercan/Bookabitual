import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookabitual/keys.dart';
import 'package:bookabitual/screens/comment/quoteComment.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/utils/avatarPictures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/models/book.dart';

class MockQuoteComment extends QuoteComment {
  MockQuoteComment(
  {text, Map<String, dynamic> comments, book, user, createTime, postID, beforeState}) : super(text: text,
  comments: comments, book: book, user: user, createTime: createTime, postID: postID, beforeState: beforeState);

  @override
  QuoteCommentState createState() => MockQuoteCommentState();
}

class MockQuoteCommentState extends QuoteCommentState {
  @override
  getAllComments() {}

  @override
  removeFunction(commentUser, comment) {
    widget.commentWidgets.removeLast();
  }

  @override
  Widget buildComment(Bookworm commentUser, String comment, Timestamp createTime) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      margin: EdgeInsets.only(bottom: 5),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(avatars[commentUser.photoIndex]),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commentUser.username,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        readTimestamp(createTime.seconds),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              commentUser.uid == currentBookworm.uid ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(icon: Icon(Icons.delete, key: Key(Keys.DeleteCommentButton),color: Colors.red[300],), onPressed: () {
                  showDialog(context: context, builder: (context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height / 5,
                        width: MediaQuery.of(context).size.width * 0.66,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Text(
                                "Do you really want to delete the comment you selected?",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.staatliches(
                                  color: Colors.black54,
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  child: FlatButton(
                                    child: Text(
                                      "yes",
                                      key: Key(Keys.YesButton),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.staatliches(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 24,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    onPressed: () async {
                                      removeFunction(commentUser, comment);
                                    },
                                  ),
                                  width: MediaQuery.of(context).size.width * 0.25,
                                ),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.25,
                                  child: FlatButton(
                                    child: Text(
                                      "no",
                                      key: Key(Keys.NoButton),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.staatliches(
                                        color: Colors.lightBlueAccent,
                                        fontSize: 24,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.maybePop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                  /**/
                }),
              ) : Container(),
            ],
          ),
          SizedBox(height: 5,),
          Container(
            padding: EdgeInsets.all(5),
            child: AutoSizeText(
              comment,
              minFontSize: 14,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[800],
                fontWeight: FontWeight.bold,
                textBaseline: TextBaseline.alphabetic,
              ),
            ),
          ),
          SizedBox(height: 5,),
          Container(
            height: 3,
            margin: EdgeInsets.only(left: 30, right: 30),
            color: Colors.grey[300],
          ),
          SizedBox(height: 5,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var firstWidget = buildInfo();
    widget.commentWidgets.add(firstWidget);
    widget.comments.keys.forEach((uid) {
      Bookworm user = new Bookworm(
        name: "Hello123",
        accountCreated: Timestamp.now(),
        email: "hello123@hello.com",
        photoIndex: 12,
        uid: "cBkdfmskAzc0T7xtAif8HcVNrCu2",
        username: "Hello123",
      );
      widget.comments[uid].keys.forEach((text) {
        widget.commentWidgets.add(buildComment(user, text, Timestamp.now()));
      });
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          "Comments",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
            color: Theme.of(context).bottomAppBarColor,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.only(bottom: 80),
              physics: BouncingScrollPhysics(),
              children: widget.commentWidgets,
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: 75,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                decoration: BoxDecoration(color: Theme
                    .of(context)
                    .accentColor),
                child: Row(
                  children: [
                    SizedBox(
                      width: 7,
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(avatars[
                      Provider
                          .of<CurrentUser>(context)
                          .getCurrentUser
                          .photoIndex]),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: controller,
                        key: Key(Keys.CommentTextField),
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.comment),
                            hintText: "Add Comment"),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        if (controller.text != "") {
                          var currentUser = Provider.of<CurrentUser>(context, listen: false).getCurrentUser;

                          setState(() {
                            widget.commentWidgets.add(buildComment(currentUser, controller.text, Timestamp.now()));
                            controller.clear();
                          });
                        }
                      },
                      child: Text(
                        "Post",
                        key: Key(Keys.PostCommentButton),
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}