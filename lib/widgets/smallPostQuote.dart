import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookabitual/screens/book/bookpage.dart';
import 'package:bookabitual/screens/comment/quoteComment.dart';
import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/utils/avatarPictures.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ProjectContainer.dart';

class SmallPostQuote extends StatefulWidget {
  final dynamic post;
  final bool canBeDeleted;

  const SmallPostQuote({Key key, @required this.post, @required this.canBeDeleted}) : super(key: key);

  @override
  _SmallPostQuoteState createState() => _SmallPostQuoteState();
}

class _SmallPostQuoteState extends State<SmallPostQuote> {
  int likeCount;
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    bool _isLiked = false;

    String readTimestamp(int timestamp) {
      var now = DateTime.now();
      var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      var diff = now.difference(date);
      var time = '';

      if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0) {
        time = 'JUST NOW';
      } else if (diff.inMinutes > 0 && diff.inMinutes < 60) {
        if (diff.inMinutes == 1) {
          time = diff.inMinutes.toString() + ' MIN AGO';
        } else {
          time = diff.inMinutes.toString() + ' MINS AGO';
        }
      } else if (diff.inHours > 0 && diff.inHours < 24) {
        if (diff.inHours == 1) {
          time = diff.inHours.toString() + ' HOUR AGO';
        } else {
          time = diff.inHours.toString() + ' HOURS AGO';
        }
      } else if (diff.inDays > 0 && diff.inDays < 7) {
        if (diff.inDays == 1) {
          time = diff.inDays.toString() + ' DAY AGO';
        } else {
          time = diff.inDays.toString() + ' DAYS AGO';
        }
      } else {
        if (diff.inDays == 7) {
          time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
        } else {
          time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
        }
      }
      return time;
    }

    int getTotalNumberOfComments(comments) {
      if (comments == null) {
        return 0;
      }
      int counter = 0;
      comments.values.forEach((value) {
        value.values.forEach((val) {
          counter = counter + 1;
        });
      });
      return counter;
    }

    int getTotalNumberOfLikes(likes) {
      if (likes == null) {
        return 0;
      }
      int counter = 0;
      likes.values.forEach((value) {
        if (value) counter = counter + 1;
      });
      return counter;
    }


    likeCount = getTotalNumberOfLikes(widget.post.likes);

    if (widget.post.likes[currentBookworm.uid] != null) {
      _isLiked = widget.post.likes[currentBookworm.uid] == true;
    } else {
      _isLiked = false;
    }

    return ProjectContainer(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage:
                        AssetImage(avatars[widget.post.user.photoIndex]),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.user.username,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            " added a quote.",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        readTimestamp(widget.post.createTime.seconds),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              widget.canBeDeleted ? IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () async {
                  postReference
                      .doc(widget.post.uid)
                      .collection("usersQuotes")
                      .doc(widget.post.postID)
                      .delete();
                  var temp = await bookReference.doc(widget.post.isbn).get();
                  var postMap = temp.data()["posts"];
                  postMap[widget.post.uid].remove(widget.post.postID);
                  if (postMap[widget.post.uid].isEmpty)
                    postMap.remove(widget.post.uid);
                  await bookReference.doc(widget.post.isbn).update({"posts": postMap});
                  widget.post.trigger();
                },
              ) : Container(),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  child: Image(
                    image: NetworkImage(widget.post.book.imageUrlM),
                    alignment: Alignment.center,
                    fit: BoxFit.fitHeight,
                  ),
                  onDoubleTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => BookPage(book: widget.post.book,),
                    ),);
                  },
                ),
                SizedBox(width: 3),
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Center(
                        child: AutoSizeText(
                          widget.post.text + "\n\n―" + widget.post.book.bookTitle + "\n " + widget.post.book.bookAuthor,
                          minFontSize: 8,
                          maxLines: 11,
                          wrapWords: true,
                          overflow: TextOverflow.clip,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.openSans(
                            fontSize: 22,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            textBaseline: TextBaseline.alphabetic,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.only(left: 7),
                child: Text(
                  getTotalNumberOfLikes(widget.post.likes).toString() + " likes",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              SizedBox(width: 20,),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuoteComment(
                        comments: widget.post.comments,
                        book: widget.post.book,
                        user: widget.post.user,
                        text: widget.post.text,
                        createTime: widget.post.createTime,
                        postID: widget.post.postID,
                      ))
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 7),
                  child: Text(
                    "View all "+ getTotalNumberOfComments(widget.post.comments).toString() + " comments",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: ()=> controlLikeQuote(),
                icon: _isLiked ? Icon(Icons.favorite, size: 35, color: Colors.red.withOpacity(1)) :
                Icon(Icons.favorite, size: 35, color: Colors.red.withOpacity(0.3),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  controlLikeQuote(){
    String currentOnlineUserId = currentBookworm.uid;
    bool _like;
    if(widget.post.likes[currentBookworm.uid] != null){
      _like = widget.post.likes[currentBookworm.uid] == true;
    }
    else{
      _like = false;
    }
    if(_like){
      postReference.doc(widget.post.uid).collection("usersQuotes").doc(widget.post.postID).update({"likes.$currentOnlineUserId": false});
      removeLike();
      setState(() {
        likeCount = likeCount - 1;
        _isLiked = false;
        widget.post.likes[currentOnlineUserId] = false;
      });
    }
    else if(!_like){
      postReference.doc(widget.post.uid).collection("usersQuotes").doc(widget.post.postID).update({"likes.$currentOnlineUserId": true});
      addLike();
      setState(() {
        likeCount = likeCount + 1;
        _isLiked = true;
        widget.post.likes[currentOnlineUserId] = true;
      });
    }
  }


  removeLike(){
    bool isNotPostOwner = currentBookworm.uid != widget.post.uid;
    if(isNotPostOwner){
      activityFeedReference.doc(widget.post.uid).collection("feedItems").doc(widget.post.postID).get().then((document){
        if(document.exists){
          document.reference.delete();
        }
      });
    }
  }

  addLike(){
    bool isNotPostOwner = currentBookworm.uid != widget.post.uid;
    if(isNotPostOwner){
      activityFeedReference.doc(widget.post.uid).collection("feedItems").doc(widget.post.postID).set({
        "type": "like",
        "username": currentBookworm.username,
        "userId": currentBookworm.uid,
        "timestamp": Timestamp.now(),
        "url": widget.post.book.imageUrlL,
        "quoteId": widget.post.postID,
        "userAvatarIndex": currentBookworm.photoIndex,
      });
    }
  }
}
