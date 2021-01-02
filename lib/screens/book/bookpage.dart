import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/screens/anotherProfile/anotherProfile.dart';
import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/utils/avatarPictures.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:bookabitual/widgets/reviewPost.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';


class BookPage extends StatefulWidget {
  final Book book;

  BookPage({Key key, this.book}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  int index = 0;
  List<String> bookState = ["Add to My Library","Finished", "Reading", "Unfinished", "Will Read"];
  List<Widget> bookStateIcon = [
    Container(),
    Icon(Icons.book, color: Colors.grey[300],),
    Icon(Icons.chrome_reader_mode, color: Colors.grey[300],),
    Icon(Icons.close_rounded, color: Colors.grey[300],),
    Icon(Icons.access_time, color: Colors.grey[300],),
  ];
  List bookPosts = [];
  List<Widget> bookPostFinal = [];
  List<bool> isReview = [];
  Future bookpageFuture;

  List<Widget> delegateList = [];

  @override
  void initState() {
    super.initState();

    bookpageFuture = getAllBookPost();

  }

  getAllBookPost() async {
    var data = await bookReference.doc(widget.book.isbn).get();
    var postMap = data.data()["posts"];

    await Future.forEach(postMap.keys, (uid) async {
      await Future.forEach(postMap[uid].keys, (postID) async {
        if (postMap[uid][postID] == "userQuotes") {
          DocumentSnapshot temp = await postReference.doc(uid).collection("usersQuotes").doc(postID).get();
          var postMap = temp.data();
          var tempPost = QuotePost(
              postID: postID,
              isbn: postMap["isbn"],
              uid: uid,
              text: postMap["text"],
              createTime: postMap["createTime"],
              status: postMap["status"],
              likes: postMap["likes"],
              trigger: reloadFuture,
              comments: postMap["comments"]
          );
          await tempPost.updateInfo();
          bookPosts.add(tempPost);
          isReview.add(false);
        } else {
          DocumentSnapshot temp = await postReference.doc(uid).collection("usersReviews").doc(postID).get();
          var postMap = temp.data();
          var tempPost = ReviewPost(
            postID: postID,
            isbn: postMap["isbn"],
            uid: uid,
            text: postMap["text"],
            createTime: postMap["createTime"],
            status: postMap["status"],
            likes: postMap["likes"],
            trigger: reloadFuture,
            comments: postMap["comments"],
            rating: postMap["rating"],
          );
          await tempPost.updateInfo();
          bookPosts.add(tempPost);
          isReview.add(true);
        }
      });
    });

    for (int i = 0; i < bookPosts.length; i++) {
      Timestamp a = bookPosts[i].createTime;
      for (int j = 0 ; j < bookPosts.length; j++) {
        Timestamp b = bookPosts[j].createTime;
        if (b.compareTo(a) < 0) {
          var temp1 = bookPosts[i];
          var temp2 = isReview[i];

          bookPosts[i] = bookPosts[j];
          bookPosts[j] = temp1;

          isReview[i] = isReview[j];
          isReview[j] = temp2;
        }
      }
    }
    bookPosts.forEach((element) {
      bookPostFinal.add(element);
    });

  }

  reloadFuture() {
    setState(() {
      bookpageFuture = getAllBookPost();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme
              .of(context)
              .accentColor,
          title: Text("bookabitual",
            style: TextStyle(
              fontSize: 22,
              fontWeight:
              FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Theme
                  .of(context)
                  .bottomAppBarColor,
            ),
          ),
          centerTitle: true,
        ),
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              collapsedHeight: MediaQuery.of(context).size.height * 0.2,
              backgroundColor: Colors.black,
              expandedHeight: MediaQuery
                  .of(context)
                  .size
                  .height * 0.5,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 20,
                      offset: Offset(0, 10),
                    ),
                  ],
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(widget.book.imageUrlL),
                    //image: NetworkImage(widget.book.imageUrlL),
                    fit: BoxFit.fitWidth,
                  ),
                ),
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 0.5,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      alignment: Alignment.center,
                      color: Colors.grey.withOpacity(0.1),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(
                                widget.book.imageUrlL
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    widget.book.bookTitle,
                    style: GoogleFonts.openSans(
                      fontSize: 27,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    "by " + widget.book.bookAuthor + ", " + widget.book.publisher + " · "
                        + widget.book.yearOfPublication.toString(),
                    style: GoogleFonts.openSans(
                      fontSize: 20,
                      color: Colors.grey[900],
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(
                  indent: MediaQuery.of(context).size.width / 7,
                  endIndent: MediaQuery.of(context).size.width / 7,
                  color: Colors.grey[400],
                  height: 20,
                  thickness: 2,
                ),
                Center(
                  child: RatingBar(
                    itemCount: 5,
                    allowHalfRating: true,
                    itemSize: 45,
                    updateOnDrag: false,
                    initialRating: double.tryParse(widget.book.ratings.replaceAll(",", ".")),
                    ratingWidget: RatingWidget(
                      full: Icon(Icons.star_rounded, color: Colors.orange[200],),
                      half: Icon(Icons.star_half_rounded, color: Colors.orange[200],),
                      empty: Icon(Icons.star_border_rounded, color: Colors.orange[200],),
                    ),
                    onRatingUpdate: null,
                  ),
                ),
                SizedBox(height: 10,),
                Container(
                  height: 50,
                  child: FittedBox(
                    child: ButtonTheme(
                      minWidth: MediaQuery.of(context).size.width * 0.66,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () => _onButtonPressed(),
                        child: Row(
                          children: [
                            bookStateIcon[index],
                            SizedBox(width: 5,),
                            Text(
                              bookState[index],
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
                Divider(
                  indent: MediaQuery.of(context).size.width / 7,
                  endIndent: MediaQuery.of(context).size.width / 7,
                  color: Colors.grey[400],
                  height: 40,
                  thickness: 2,
                ),
              ]),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  child: FutureBuilder(
                    future: bookpageFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        int index = 0;
                        return Column(
                          children: bookPostFinal.map((e) {
                            var temp = buildBookPost(e, isReview[index]);
                            index++;
                            return temp;
                          }).toList(),
                        );
                      }
                      else
                        return Center(child: CircularProgressIndicator());
                    },
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }

  void _onButtonPressed() {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        color: Colors.transparent,
        child: Container(
          child: _buildBottomNavigationMenu(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(10),
              topRight: const Radius.circular(10),
            )
          ),
        ),
      );
    });
  }

  Container _buildBottomNavigationMenu(){
    return Container(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Finished'),
            onTap: (){
              setState(() {
                index = 1;
              });
              Navigator.maybePop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.chrome_reader_mode),
            title: Text('Reading'),
            onTap: (){
              setState(() {
                index = 2;
              });
              Navigator.maybePop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.close_rounded),
            title: Text('Unfinished'),
            onTap: (){
              setState(() {
                index = 3;
              });
              Navigator.maybePop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Will Read'),
            onTap: (){
              setState(() {
                index = 4;
              });
              Navigator.maybePop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget buildBookPost(dynamic post, bool isReview) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.85,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 20.0,
                  spreadRadius: 1.0,
                  offset: Offset(
                      2.0,
                      2.0)
                  ,)
              ],
            ),
            child: Card(
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    AutoSizeText(
                      post.text,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black54
                      ),
                    ),
                    SizedBox(height: 5,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                child: CircleAvatar(
                                  radius: 14,
                                  backgroundImage: AssetImage(avatars[post.user.photoIndex]),
                                ),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AnotherProfilePage(user: post.user,),
                                  ),);
                                },
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    post.user.username,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    readTimestamp(post.createTime.seconds),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            child: Text(
                              getTotalNumberOfLikes(post.likes).toString() + " likes",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              getTotalNumberOfComments(post.comments).toString() + " comments",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          isReview ? Container(
                            child: Row(
                              children: [
                                Icon(Icons.star_rounded, color: Colors.amber),
                                Text(post.rating, style: TextStyle(
                                  color: Colors.amber
                                ),),
                              ],
                            ),
                          ) : Container(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(
          indent: MediaQuery.of(context).size.width / 7,
          endIndent: MediaQuery.of(context).size.width / 7,
          color: Colors.grey[400],
          height: 40,
          thickness: 2,
        ),
      ],
    );
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
}
