import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/service/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/avatarPictures.dart';
import 'ProjectContainer.dart';

class ReviewPost extends StatefulWidget {
  final String reviewId;
  final String ownerId;
  final int userAvatarIndex;
  final String username;
  final Timestamp createTime;
  final String status;
  final String imageUrl;
  final dynamic likes;
  final String review;
  final String author;
  final String bookName;
  final double rating;
  var date;

  ReviewPost({Key key, this.reviewId, this.ownerId, this.review, this.rating,this.author, this.bookName, this.status,
    this.userAvatarIndex, this.username, this.imageUrl, this.createTime, this.likes}) : super(key: key) {
    date = DateTime.fromMillisecondsSinceEpoch(createTime.millisecondsSinceEpoch);
  }

  factory ReviewPost.fromDocument(DocumentSnapshot documentSnapshot){
    return ReviewPost(
      reviewId: documentSnapshot["reviewId"],
      ownerId: documentSnapshot["ownerId"],
      userAvatarIndex: documentSnapshot["userAvatarIndex"],
      username: documentSnapshot["username"],
      createTime: documentSnapshot["createTime"],
      status: documentSnapshot["status"],
      imageUrl: documentSnapshot["imageUrl"],
      likes: documentSnapshot["likes"],
      review: documentSnapshot["review"],
      author: documentSnapshot["author"],
      bookName: documentSnapshot["bookName"],
      rating: documentSnapshot["rating"],
    );
  }

  int getTotalNumberOfLikes(likes){
    if(likes == null){
      return 0;
    }
    int counter = 0;
    likes.values.forEach((value){
      counter = counter + 1;
    });
    return counter;
  }

  @override
  _ReviewPostState createState() => _ReviewPostState(
    reviewId: this.reviewId,
    ownerId: this.ownerId,
    review: this.review,
    author: this.author,
    bookName: this.bookName,
    status: this.status,
    userAvatarIndex: this.userAvatarIndex,
    username: this.username,
    imageUrl: this.imageUrl,
    rating: this.rating,
    likes: this.likes,
    likeCount: getTotalNumberOfLikes(this.likes),
  );
}

class _ReviewPostState extends State<ReviewPost> {
  final String reviewId;
  final String ownerId;
  final int userAvatarIndex;
  final String username;
  final String status;
  final String imageUrl;
  Map likes;
  final String review;
  final String author;
  final String bookName;
  final double rating;
  int likeCount;
  bool _isLiked = false;
  final currentOnlineUserId = currentBookworm.uid;

  _ReviewPostState({this.reviewId, this.ownerId, this.review, this.rating,this.author, this.bookName, this.status,
    this.userAvatarIndex, this.username, this.imageUrl, this.likes, this.likeCount});

  @override
  Widget build(BuildContext context) {
    bool isQuoteOwner = currentOnlineUserId == ownerId;

    if(likes[currentOnlineUserId] != null){
      _isLiked = likes[currentOnlineUserId] == true;
    }
    else{
      _isLiked = false;
    }

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
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(avatars[widget.userAvatarIndex]),
                  ),
                  SizedBox(width: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.username,
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
                        DateFormat.yMMMd().format(widget.date) + " ~ " + widget.status,
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
                onPressed: ()=> print("deleted"),
              ) : Text(""),
            ],
          ),
          SizedBox(height: 10,),
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.width - 50,
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
                    colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.colorBurn),
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 25),
                    child: Center(
                      child: AutoSizeText(
                        widget.review + "\n\n―" + widget.author + " " + widget.bookName,
                        overflow: TextOverflow.ellipsis,
                        minFontSize: 14,
                        maxLines: 12,
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic,
                          textBaseline: TextBaseline.alphabetic,
                          shadows: [
                            Shadow(
                              offset: Offset(-2, -2),
                              color: Colors.grey[900],
                            ),
                            Shadow(
                              offset: Offset(2, -2),
                              color: Colors.grey[900],
                            ),
                            Shadow(
                              offset: Offset(2, 2),
                              color: Colors.grey[900],
                            ),
                            Shadow(
                              offset: Offset(-2, 2),
                              color: Colors.grey[900],
                            ),
                          ],
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
          Text(
            likeCount.toString() + " likes",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  controlLikeReview(){
    bool _like;
    if(likes[currentOnlineUserId] != null){
      _like = likes[currentOnlineUserId] == true;
    }
    else{
      _like = false;
    }
    if(_like){
      postReference.doc(ownerId).collection("usersQuotes").doc(reviewId).update({"likes.$currentOnlineUserId": false});
      removeLike();
      setState(() {
        likeCount = likeCount - 1;
        _isLiked = false;
        likes[currentOnlineUserId] = false;
      });
    }
    else if(!_like){
      postReference.doc(ownerId).collection("usersQuotes").doc(reviewId).update({"likes.$currentOnlineUserId": true});
      addLike();
      setState(() {
        likeCount = likeCount + 1;
        _isLiked = true;
        likes[currentOnlineUserId] = true;
      });
    }
  }

  removeLike(){
    bool isNotPostOwner = currentOnlineUserId != ownerId;
    if(isNotPostOwner){
      activityFeedReference.doc(ownerId).collection("feedItems").doc(reviewId).get().then((document){
        if(document.exists){
          document.reference.delete();
        }
      });
    }
  }

  addLike(){
    bool isNotPostOwner = currentOnlineUserId != ownerId;
    if(isNotPostOwner){
      activityFeedReference.doc(ownerId).collection("feedItems").doc(reviewId).set({
        "type": "like",
        "username": currentBookworm.username,
        "userId": currentBookworm.uid,
        "timestamp": Timestamp.now(),
        "url": imageUrl,
        "quoteId": reviewId,
        "userAvatarIndex": currentBookworm.photoIndex,
      });
    }
  }

}
