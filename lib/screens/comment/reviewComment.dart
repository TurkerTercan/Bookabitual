import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/utils/avatarPictures.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewComment extends StatefulWidget {
  final Book book;
  final Bookworm user;
  final String text;
  final dynamic comments;
  final Timestamp createTime;
  final String postID;
  final StateSetter beforeState;

  ReviewComment(
      {Key key,
      this.text,
      this.comments,
      this.book,
      this.user,
      this.createTime,
      this.postID,
      this.beforeState})
      : super(key: key);

  @override
  _ReviewCommentState createState() => _ReviewCommentState();
}

class _ReviewCommentState extends State<ReviewComment> {
  final TextEditingController _controller = new TextEditingController();
  List<Widget> commentWidgets = <Widget>[];

  Future commentFuture;

  @override
  void initState() {
    commentFuture = _getAllComments();
    super.initState();
  }

  _getAllComments() async {
    List unsorted = [];
    await Future.delayed(Duration(milliseconds: 100));
    await Future.forEach(widget.comments.keys, (element) async {
      Bookworm user = await BookDatabase().getUserInfo(element);
      widget.comments[element].forEach((key, value) {
        var temp = [user, key, value];
        unsorted.add(temp);
      });
    });

    unsorted.sort((a, b) {
      Timestamp temp1 = a[2];
      Timestamp temp2 = b[2];
      return temp2.compareTo(temp1);
    });

    List<Widget> contained = [];
    unsorted.forEach((element) {
      var temp = buildComment(element[0], element[1], element[2]);
      contained.add(temp);
    });
    var column = new Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      margin: EdgeInsets.only(bottom: 5),
      child: ProjectContainer(
        child: Container(
          child: Column(
            children: contained,
          ),
        ),
      ),
    );
    if (contained.length != 0) commentWidgets.add(column);
  }

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

  @override
  Widget build(BuildContext context) {
    var firstWidget = buildInfo();
    commentWidgets.add(firstWidget);

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
      body: FutureBuilder(
          future: commentFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                child: Stack(
                  children: [
                    ListView(
                      padding: EdgeInsets.only(bottom: 80),
                      physics: BouncingScrollPhysics(),
                      children: commentWidgets,
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        height: 75,
                        width: MediaQuery.of(context).size.width,
                        decoration:
                            BoxDecoration(color: Theme.of(context).accentColor),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 7,
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: AssetImage(avatars[
                                  Provider.of<CurrentUser>(context)
                                      .getCurrentUser
                                      .photoIndex]),
                            ),
                            SizedBox(
                              width: 7,
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _controller,
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.comment),
                                    hintText: "Add Comment"),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (_controller.text != "") {
                                  var currentUser = Provider.of<CurrentUser>(
                                          context,
                                          listen: false)
                                      .getCurrentUser;


                                  if (widget.comments[currentUser.uid] ==
                                      null) {
                                    widget.comments[currentUser.uid] =
                                        new Map<String, Timestamp>();
                                    widget.comments[currentUser.uid]
                                        [_controller.text] = Timestamp.now();
                                  } else {
                                    widget.comments[currentUser.uid]
                                        [_controller.text] = Timestamp.now();
                                  }
                                  postReference
                                      .doc(widget.user.uid)
                                      .collection("usersReviews")
                                      .doc(widget.postID)
                                      .update({"comments": widget.comments});
                                  setState(() {
                                    commentWidgets.clear();
                                    commentFuture = _getAllComments();
                                    _controller.clear();
                                  });
                                }
                              },
                              child: Text(
                                "Post",
                                style: TextStyle(fontSize: 18),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget buildComment(
      Bookworm commentUser, String comment, Timestamp createTime) {
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
                    backgroundImage:
                        AssetImage(avatars[commentUser.photoIndex]),
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
                child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red[300],),
                    onPressed: () {
                      widget.comments[commentUser.uid].remove(comment);
                      if (widget.comments[commentUser.uid].isEmpty)
                        widget.comments.remove(commentUser.uid);
                      postReference
                          .doc(widget.user.uid)
                          .collection("usersReviews")
                          .doc(widget.postID)
                          .update({"comments": widget.comments});
                      setState(() {
                        commentWidgets.clear();
                        commentFuture = _getAllComments();
                      });
                    }),
              ) : Container(),
            ],
          ),
          SizedBox(
            height: 5,
          ),
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
          SizedBox(
            height: 5,
          ),
          Container(
            height: 3,
            margin: EdgeInsets.only(left: 30, right: 30),
            color: Colors.grey[300],
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }

  Widget buildInfo() {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      margin: EdgeInsets.only(bottom: 5),
      child: ProjectContainer(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundImage: AssetImage(avatars[widget.user.photoIndex]),
                ),
                SizedBox(
                  width: 3,
                ),
                Column(
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
                      readTimestamp(widget.createTime.seconds),
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
            SizedBox(
              height: 5,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).primaryColor,
                border: Border.all(color: Theme.of(context).accentColor),
              ),
              padding: EdgeInsets.all(5),
              child: AutoSizeText(
                widget.text +
                    "\n\n―" +
                    widget.book.bookAuthor +
                    " " +
                    widget.book.bookTitle,
                minFontSize: 14,
                maxLines: 12,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 25,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
