import 'package:bookabitual/keys.dart';
import 'package:bookabitual/screens/comment/quoteComment.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/utils/avatarPictures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MockQuoteComment extends QuoteComment {
  MockQuoteComment(
  {text, comments, book, user, createTime, postID, beforeState}) : super(text: text,
  comments: comments, book: book, user: user, createTime: createTime, postID: postID, beforeState: beforeState);

  @override
  QuoteCommentState createState() => MockQuoteCommentState();
}

class MockQuoteCommentState extends QuoteCommentState {

  @override
  void initState() {
    super.initState();
    var firstWidget = buildInfo();
    widget.commentWidgets.add(firstWidget);
  }

  @override
  Widget build(BuildContext context) {
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
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.comment),
                            hintText: "Add Comment"),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
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