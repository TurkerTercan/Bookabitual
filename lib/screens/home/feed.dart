
import 'dart:ui';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget{
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          "bookabitual",
          style: TextStyle(
            fontSize: 22,
            fontWeight:
            FontWeight.bold,
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
        padding: EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                children: [
                  QuotePost(
                    author: "J.R.R. Tolkien",
                    bookName: "The Hobbit, or There and Back Again",
                    createTime: Timestamp.now(),
                    imageUrl: "https://images-na.ssl-images-amazon.com/images/I/A1E+USP9f8L.jpg",
                    likeCount: 245,
                    profileUrl: "https://images.pexels.com/photos/1499327/pexels-photo-1499327.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                    quote: "“There is nothing like looking, if you want to find something. You certainly usually find something, if you look, but it is not always quite the something you were after.”",
                    status: "Reading",
                    username: "Tom Smith",
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}