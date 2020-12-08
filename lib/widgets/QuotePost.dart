import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils/avatarPictures.dart';
import 'ProjectContainer.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class QuotePost extends StatefulWidget {
  final String quoteId;
  final String ownerId;
  final int userAvatarIndex;
  final String username;
  final Timestamp createTime;
  final String status;
  final String imageUrl;
  final int likeCount;
  final String quote;
  final String author;
  final String bookName;
  var date;

  QuotePost({Key key, this.quoteId, this.ownerId, this.quote, this.author, this.bookName, this.status,
  this.userAvatarIndex, this.username, this.imageUrl, this.createTime, this.likeCount}) : super(key: key) {
    date = DateTime.fromMillisecondsSinceEpoch(createTime.millisecondsSinceEpoch);
  }

  @override
  _QuotePostState createState() => _QuotePostState();
}

class _QuotePostState extends State<QuotePost> {
  bool _isLiked = false;
  @override
  Widget build(BuildContext context) {
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
                            " added a quote.",
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
              Icon(Icons.more_vert),
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
                  child: Center(
                    child: AutoSizeText(
                      widget.quote + "\n\n―" + widget.author + " " + widget.bookName,
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
                  onPressed: () {
                    setState(() {
                      _isLiked = !_isLiked;
                    });
                  },
                  icon: _isLiked ? Icon(Icons.favorite, size: 35, color: Colors.white.withOpacity(0.7)) :
                  Icon(Icons.favorite, size: 35, color: Colors.red.withOpacity(1),),
                ),
              ),
            ],
          ),
          SizedBox(height: 5,),
          Text(
            widget.likeCount.toString() + " likes",
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
}
