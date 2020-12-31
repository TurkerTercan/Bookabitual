import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/screens/anotherProfile/anotherProfile.dart';
import 'package:bookabitual/screens/book/bookpage.dart';
import 'package:bookabitual/screens/comment/reviewComment.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/service/database.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/avatarPictures.dart';
import 'ProjectContainer.dart';

// ignore: must_be_immutable
class ReviewPost extends StatefulWidget {
  final String isbn;
  final String uid;
  final String postID;
  final String text;
  final String rating;
  final Timestamp createTime;
  final String status;
  final dynamic likes;
  final dynamic comments;
  final Function trigger;
  Bookworm user;
  Book book;

  ReviewPost({Key key,
    @required this.postID,
    @required this.isbn,
    @required this.rating,
    @required this.uid,
    @required this.text,
    @required this.createTime,
    @required this.status,
    @required this.likes,
    @required this.trigger,
    @required this.comments
  }) : super(key: key);


  int getTotalNumberOfLikes(likes){
    if(likes == null){
      return 0;
    }
    int counter = 0;
    likes.values.forEach((value){
      if (value)
        counter = counter + 1;
    });
    return counter;
  }

  updateInfo() async {
    user = await BookDatabase().getUserInfo(uid);
    book = await BookDatabase().getBookInfo(isbn);
  }

  @override
  _ReviewPostState createState() => _ReviewPostState(
    likes: this.likes,
    likeCount: getTotalNumberOfLikes(this.likes),
  );
}

class _ReviewPostState extends State<ReviewPost> {

  int likeCount;
  bool _isLiked = false;
  Map likes;

  Future reviewFuture;
  final currentOnlineUserId = currentBookworm.uid;

  _ReviewPostState({this.likes, this.likeCount});

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 || diff.inSeconds > 0 && diff.inMinutes == 0 ) {
      time = 'JUST NOW';
    } else if(diff.inMinutes > 0 && diff.inMinutes < 60) {
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

  @override
  Widget build(BuildContext context) {
    bool isQuoteOwner = currentOnlineUserId == widget.uid;
    _isLiked = likes[currentOnlineUserId] == true;

    return ProjectContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(avatars[widget.user.photoIndex]),
                    ),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) => AnotherProfilePage(user: widget.user,),
                      ),);
                    },
                  ),
                  SizedBox(width: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user.username,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            " added a review.",
                            style: TextStyle(
                              fontSize: 16 ,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        readTimestamp(widget.createTime.seconds),
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
              isQuoteOwner ? IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () {
                  postReference.doc(widget.uid).collection("usersReviews").doc(widget.postID).delete();
                  widget.trigger();
                },
              ) : Container(),
            ],
          ),
          SizedBox(height: 10,),
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                  image: DecorationImage(
                    colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.55), BlendMode.darken),
                    image: CachedNetworkImageProvider(widget.book.imageUrlL),
                    // image: NetworkImage(widget.book.imageUrlL),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Center(
                      child: GestureDetector(
                        onDoubleTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => BookPage(book: widget.book,),
                          ),);
                        },
                        child: AutoSizeText(
                          widget.text + "\n\n―" + widget.book.bookTitle + ",\n" + widget.book.bookAuthor + "\n",
                          overflow: TextOverflow.ellipsis,
                          minFontSize: 8,
                          maxLines: 17,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.openSans(
                            fontSize: 25,
                            color: Colors.grey[400],
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            textBaseline: TextBaseline.alphabetic,
                            shadows: [
                              Shadow(
                                offset: Offset(-2, -2),
                                color: Colors.grey[900],
                                blurRadius: 8,
                              ),
                              Shadow(
                                offset: Offset(2, -2),
                                color: Colors.grey[900],
                                blurRadius: 8,
                              ),
                              Shadow(
                                offset: Offset(2, 2),
                                color: Colors.grey[900],
                                blurRadius: 8,
                              ),
                              Shadow(
                                offset: Offset(-2, 2),
                                color: Colors.grey[900],
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 15,
                left: 12,
                child: Row(
                  children: [
                    Icon(Icons.star, size: 35, color: Colors.yellow.withOpacity(0.7),),
                    SizedBox(width: 5,),
                    Text(
                      widget.rating.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.yellow[300],
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  onPressed: ()=> controlLikeReview(),
                  icon: _isLiked ? Icon(Icons.favorite, size: 35, color: Colors.red.withOpacity(1)) :
                  Icon(Icons.favorite, size: 35, color: Colors.white.withOpacity(0.7),),
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                likeCount.toString() + " likes",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ReviewComment(
                        comments: widget.comments,
                        book: widget.book,
                        user: widget.user,
                        text: widget.text,
                        createTime: widget.createTime,
                        postID: widget.postID,
                      ))
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(right: 7),
                  child: Text(
                    "View all "+ getTotalNumberOfComments(widget.comments).toString() + " comments",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  controlLikeReview(){
    bool _like = likes[currentOnlineUserId] == true;

    if(_like){
      postReference.doc(widget.uid)
          .collection("usersReviews")
          .doc(widget.postID)
          .update({"likes.$currentOnlineUserId": false});
      removeLike();
      setState(() {
        likeCount = likeCount - 1;
        _isLiked = false;
        likes[currentOnlineUserId] = false;
      });
    }
    else if(!_like){
      postReference.doc(widget.uid)
          .collection("usersReviews")
          .doc(widget.postID)
          .update({"likes.$currentOnlineUserId": true});
      addLike();
      setState(() {
        likeCount = likeCount + 1;
        _isLiked = true;
        likes[currentOnlineUserId] = true;
      });
    }
  }

  removeLike(){
    bool isNotPostOwner = currentOnlineUserId != widget.uid;
    if(isNotPostOwner){
      activityFeedReference.doc(widget.uid)
          .collection("feedItems")
          .doc(widget.postID)
          .get()
          .then((document){
        if(document.exists){
          document.reference.delete();
        }
      });
    }
  }

  addLike(){
    bool isNotPostOwner = currentOnlineUserId != widget.uid;
    if(isNotPostOwner){
      activityFeedReference
          .doc(widget.uid)
          .collection("feedItems")
          .doc(widget.postID)
          .set({
        "type": "like",
        "username": currentBookworm.username,
        "userId": currentBookworm.uid,
        "timestamp": Timestamp.now(),
        "url": widget.book.imageUrlL,
        "quoteId": widget.postID,
        "userAvatarIndex": currentBookworm.photoIndex,
      });
    }
  }

}
