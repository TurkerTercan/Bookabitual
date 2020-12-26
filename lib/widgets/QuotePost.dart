import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/avatarPictures.dart';
import 'ProjectContainer.dart';

// ignore: must_be_immutable
class QuotePost extends StatefulWidget {
  final String isbn;
  final String uid;
  final String postID;
  final String text;
  final Timestamp createTime;
  final String status;
  final dynamic likes;
  Bookworm user;
  Book book;

  QuotePost({Key key, this.postID,
    this.isbn,
    this.uid, this.text,
    this.createTime, this.status,
    this.likes}) : super(key: key);

  factory QuotePost.fromDocument(DocumentSnapshot documentSnapshot){
    return QuotePost(
      isbn: documentSnapshot.data()["isbn"],
      uid: documentSnapshot.data()["uid"],
      postID: documentSnapshot.data()["postID"],
      createTime: documentSnapshot.data()["createTime"],
      likes: documentSnapshot.data()["likes"],
      status: documentSnapshot.data()["status"],
      text: documentSnapshot.data()["text"],
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

  updateInfo() async {
    user = await BookDatabase().getUserInfo(uid);
    book = await BookDatabase().getBookInfo(isbn);
  }

  @override
  _QuotePostState createState() => _QuotePostState(
    likes: this.likes,
    likeCount: getTotalNumberOfLikes(this.likes),
  );
}

class _QuotePostState extends State<QuotePost> {
  int likeCount;
  bool _isLiked = false;
  Map likes;

  Future reviewFuture;
  final currentOnlineUserId = currentBookworm.uid;

  _QuotePostState({this.likes, this.likeCount});

  @override
  Widget build(BuildContext context) {
    bool isQuoteOwner = currentOnlineUserId == widget.uid;

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
                    backgroundImage: AssetImage(avatars[widget.user.photoIndex]),
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
                            " added a quote.",
                            style: TextStyle(
                              fontSize: 16 ,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        "1m ago!",
                        //TODO : Implement Date format
                        //DateFormat.yMMMd().format(widget.date) + " ~ " + widget.status,
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
                    image: NetworkImage(widget.book.imageUrlL),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: AutoSizeText(
                      widget.text + "\n\n―" + widget.book.bookAuthor + " " + widget.book.bookTitle,
                      minFontSize: 14,
                      maxLines: 12,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey[400],
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
              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  onPressed: ()=> controlLikeQuote(),
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

  controlLikeQuote(){
    bool _like;
    if(likes[currentOnlineUserId] != null){
      _like = likes[currentOnlineUserId] == true;
    }
    else{
      _like = false;
    }
    if(_like){
      postReference.doc(widget.uid).collection("usersQuotes").doc(widget.postID).update({"likes.$currentOnlineUserId": false});
      removeLike();
      setState(() {
        likeCount = likeCount - 1;
        _isLiked = false;
        likes[currentOnlineUserId] = false;
      });
    }
    else if(!_like){
      postReference.doc(widget.uid).collection("usersQuotes").doc(widget.postID).update({"likes.$currentOnlineUserId": true});
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
      activityFeedReference.doc(widget.uid).collection("feedItems").doc(widget.postID).get().then((document){
        if(document.exists){
          document.reference.delete();
        }
      });
    }
  }

  addLike(){
    bool isNotPostOwner = currentOnlineUserId != widget.uid;
    if(isNotPostOwner){
      activityFeedReference.doc(widget.uid).collection("feedItems").doc(widget.postID).set({
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

