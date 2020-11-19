
import 'dart:ui';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:bookabitual/widgets/reviewPost.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FeedPage extends StatefulWidget{
  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  int _selectedItemIndex = 0;
  List<Widget> postList = [
    QuotePost(
      author: "J.R.R. Tolkien",
      bookName: "The Hobbit, or There and Back Again",
      createTime: Timestamp.now(),
      imageUrl: "https://images-na.ssl-images-amazon.com/images/I/A1E+USP9f8L.jpg",
      likeCount: 245,
      profileUrl: "https://images.pexels.com/photos/1499327/pexels-photo-1499327.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      quote: "“There is nothing like looking, if you want to find something. "
          "You certainly usually find something, if you look, but it is not always quite "
          "the something you were after.”",
      status: "Reading",
      username: "Tom Smith",
    ),
    ReviewPost(
      author: "Colin Grant",
      bookName: "A Smell Of Burning",
      createTime: Timestamp.now(),
      imageUrl: "https://img.rasset.ie/000d7a28-614.jpg?ratio=0.6",
      likeCount: 476,
      profileUrl: "https://images.pexels.com/photos/1081685/pexels-photo-1081685.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
      review: "I realise this might be of minority interest if, unlike me, you haven’t spent your whole adult life with epilepsy being front and centre, but bear with me."
          "\nIt’s part thorough history of the condition, part look into what it actually is and how it works and part movingly human story about"
          " Grant’s own personal interest in epilepsy through the story of his brother.",
      status: "Finished",
      username: "Alan Wake",
      rating: 3.5,
    ),
  ];
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
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
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Container(
        height: 50,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
            elevation: 15,
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            buildNavBarItem(Icons.home, 0),
            buildNavBarItem(Icons.search, 1),
            buildNavBarItem(Icons.person, 2),
          ],
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 50,
        child: Container(
          child: Icon(
            icon,
            size: 30,
            color: index == _selectedItemIndex ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }
}