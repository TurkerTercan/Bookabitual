import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookabitual/keys.dart';
import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/screens/book/bookpage.dart';
import 'package:bookabitual/screens/profile/listOfUsers.dart';
import 'package:bookabitual/screens/root/root.dart';
import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/utils/avatarPictures.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:bookabitual/widgets/QuotePost.dart';
import 'package:bookabitual/widgets/reviewPost.dart';
import 'package:bookabitual/widgets/smallPostQuote.dart';
import 'package:bookabitual/widgets/smallPostReview.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/bookworm.dart';
import '../../states/currentUser.dart';

class ProfilePage extends StatefulWidget {

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  Bookworm currentUser;
  int currentIndex;
  final List postList = <Widget>[];
  final Map<Widget, bool> postMap = {};
  List<Widget> reviewPosts = <Widget>[];
  List<Widget> quotePosts = <Widget>[];
  final List boolList = [];
  final List<Book> libraryBooks = [];

  Future profileFuture;

  final GlobalKey<RefreshIndicatorState> _globalKey = new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    currentUser = currentBookworm;
    profileFuture = getAllPosts(currentUser.uid);
  }

  void triggerFuture() {
    setState(() {
      profileFuture = getAllPosts(currentUser.uid);
    });
  }

  void setCurrentBookworm() {
    setState(() {
      currentUser = currentBookworm;
    });
  }

  getAllPosts(String uid) async {
    postList.clear();
    reviewPosts.clear();
    quotePosts.clear();
    boolList.clear();
    postMap.clear();

    QuerySnapshot queryQuoteSnapshot = await BookDatabase().getUserQuotes(uid);
    QuerySnapshot queryReviewSnapshot = await BookDatabase().getUserReviews(uid);


    reviewPosts = queryReviewSnapshot.docs.map((documentSnapshot)  {
      ReviewPost reviewPost = ReviewPost(
        isbn: documentSnapshot.data()["isbn"],
        uid: documentSnapshot.data()["uid"],
        postID: documentSnapshot.data()["postID"],
        createTime: documentSnapshot.data()["createTime"],
        likes: documentSnapshot.data()["likes"],
        rating: documentSnapshot.data()["rating"],
        status: documentSnapshot.data()["status"],
        text: documentSnapshot.data()["text"],
        comments: documentSnapshot.data()["comments"],
        trigger: triggerFuture,
      );
      boolList.add(true);
      return reviewPost;
    }).toList();

    await Future.forEach(reviewPosts, (element) async {
      await element.updateInfo();
    });

    postList.addAll(reviewPosts);

    quotePosts = queryQuoteSnapshot.docs.map((documentSnapshot) {
      QuotePost quotePost = QuotePost(
        isbn: documentSnapshot.data()["isbn"],
        uid: documentSnapshot.data()["uid"],
        postID: documentSnapshot.data()["postID"],
        createTime: documentSnapshot.data()["createTime"],
        likes: documentSnapshot.data()["likes"],
        status: documentSnapshot.data()["status"],
        text: documentSnapshot.data()["text"],
        comments: documentSnapshot.data()["comments"],
        trigger: triggerFuture,
      );
      boolList.add(false);
      return quotePost;
    }).toList();

    await Future.forEach(quotePosts, (element) async {
      await element.updateInfo();
    });

    postList.addAll(quotePosts);

    for (int i = 0; i < postList.length; i++) {
      Timestamp a = postList[i].createTime;
      for (int j = 0 ; j < postList.length; j++) {
        Timestamp b = postList[j].createTime;
        if (b.compareTo(a) < 0) {
          var temp1 = postList[i];
          var temp2 = boolList[i];

          postList[i] = postList[j];
          postList[j] = temp1;

          boolList[i] = boolList[j];
          boolList[j] = temp2;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    currentUser = Provider.of<CurrentUser>(context).getCurrentUser;
    nameController.text = currentUser.name;
    currentIndex = currentUser.photoIndex;

    ScrollController _scrollController = new ScrollController();

    return Container(
      child: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 1.1,
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ProjectContainer(
                      child: Column(
                        children: [
                          Center(
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage(avatars[currentUser.photoIndex]),
                              radius: 40.0,
                            ),
                          ),
                          Divider(
                            height: 7,
                            color: Colors.green[100],
                          ),
                          Text(
                            currentUser.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                                letterSpacing: 1.0,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.bold),
                          ),
                          Divider(
                            height: 5,
                            color: Colors.green[100],
                          ),
                          Text(
                            currentUser.username,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.black45,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    height: 12,
                    color: Colors.green[100],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => BookPage(book: currentBookworm.currentBook,)));
                      },
                      child: AutoSizeText.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                text: currentBookworm.currentBookName != "" ? 'I am reading ' : "",
                                style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.grey[600],
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              TextSpan(
                                text: currentBookworm.currentBookName != "" ? currentBookworm.currentBook.bookTitle : "",
                                style: TextStyle(
                                    fontSize: 22.0,
                                    color: Colors.grey[850],
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                        ),
                        minFontSize: 15,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Divider(
                    height: 10,
                    color: Colors.green[100],
                    thickness: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: TextButton(
                          onPressed: () {
                            List<String> uids = currentUser.followers.keys.toList();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ListOfUsers(uids: uids, title: "Followers",)));
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  currentUser.followers.length.toString(),
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Followers",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: TextButton(
                          onPressed: () {
                            List<String> uids = currentUser.following.keys.toList();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ListOfUsers(uids: uids, title: "Following",)));
                          },
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  currentUser.following.length.toString(),
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Following",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.black45,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        appBar: TabBar(
                          isScrollable: true,
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.grey,
                          labelStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                          unselectedLabelStyle:
                              TextStyle(fontSize: 18.0, color: Colors.grey),
                          indicator: UnderlineTabIndicator(
                            borderSide:
                                BorderSide(width: 2.0, color: Colors.blueGrey),
                          ),
                          tabs: [
                            Tab(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: Center(
                                  child: Text("My Posts"),
                                ),
                              ),
                            ),
                            Tab(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.43,
                                child: Center(
                                  child: Text("My Library"),
                                  widthFactor: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        body: TabBarView(
                          children: [
                            Container(  //My Posts Tab
                              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                              child: FutureBuilder(
                                future: profileFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done) {
                                    if (postList.length == 0)
                                      return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: ProjectContainer(
                                              child: Text(
                                                "There is nothing to show here. \nShare some of your favorite books!",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      );
                                    else {
                                      return RefreshIndicator(
                                        key: _globalKey,
                                        onRefresh: () {
                                          return Future.delayed(
                                              Duration(milliseconds: 1))
                                              .then((value) =>
                                          {
                                            setState(() {
                                              profileFuture = getAllPosts(currentUser.uid);
                                            })
                                          });
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context).size.height * 0.75,
                                          child: ListView.builder(
                                            controller: _scrollController,
                                            physics: BouncingScrollPhysics(),
                                            itemCount: postList.length,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return Container(
                                                padding: EdgeInsets.only(
                                                    left: 5,
                                                    right: 5,
                                                    top: 10),
                                                margin: EdgeInsets.only(
                                                    bottom: 5),
                                                child: boolList[index] ? SmallPostReview(post: postList[index], canBeDeleted: true,)
                                                    : SmallPostQuote(post: postList[index], canBeDeleted: true,),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  else {
                                    return Column(
                                      children: [
                                        SizedBox(height: 25,),
                                        Center(child: CircularProgressIndicator()),
                                      ],
                                    );
                                  }
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                              child: Container(  //MY Library Tab,
                                child: GridView.builder(
                                  itemCount: currentUser.library.keys.length,
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5,
                                    childAspectRatio: 4 / 6,
                                  ),
                                  itemBuilder: (context, index) {
                                    return FutureBuilder(
                                      future: getBookData(currentUser.library.keys.elementAt(index), index),
                                      builder: (context, snapshot) {
                                        return Card(
                                          elevation: 20,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => BookPage(book: libraryBooks[index], funct: setCurrentBookName,))
                                              );
                                              },
                                            child: Container(
                                              child: snapshot.connectionState != ConnectionState.done ?
                                                  Center(child: CircularProgressIndicator())
                                              : Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  image: DecorationImage(
                                                    image: CachedNetworkImageProvider(libraryBooks[index].imageUrlL),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50), topRight: Radius.circular(30)),
                                                        color: Colors.amber,
                                                        gradient: LinearGradient(
                                                          begin: Alignment.topLeft,
                                                          end: Alignment.bottomRight,
                                                          colors: [Colors.white, Colors.grey[500]],
                                                        ),
                                                      ),
                                                      child: currentUser.library[libraryBooks[index].isbn] == "Finished" ? Icon(
                                                        Icons.book,
                                                        size: 25,
                                                      ) : currentUser.library[libraryBooks[index].isbn] == "Reading" ? Icon(
                                                        Icons.chrome_reader_mode,
                                                        size: 25,
                                                      ) : currentUser.library[libraryBooks[index].isbn] == "Unfinished" ? Icon(
                                                        Icons.close_rounded,
                                                        size: 25,
                                                      ) : Icon(
                                                        Icons.access_time,
                                                        size: 25,
                                                      ),
                                                      padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 20),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      initialIndex: 0,
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 25,
                top: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            editModalBottomSheet(setState);
                          },
                          key: Key(Keys.EditButton),
                          icon: Icon(
                            Icons.edit,
                            size: 35,
                          ),
                          color: Colors.amber,
                          iconSize: 25.0,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        IconButton(
                          key: Key(Keys.LogoutButton),
                          onPressed: () async {
                            CurrentUser _current =
                            Provider.of<CurrentUser>(context, listen: false);
                            String _returnString = await _current.signOut();
                            if (_returnString == "Success") {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RootPage()),
                                      (route) => false);
                            }
                          },
                          icon: Icon(
                            Icons.logout,
                            size: 35,
                          ),
                          color: Colors.amber,
                          iconSize: 25.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  editModalBottomSheet(StateSetter beforeState)  {
     showModalBottomSheet<dynamic>(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      )),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                child: ListView(
                  padding: EdgeInsets.all(10.0),
                  children: <Widget>[
                    ProjectContainer(
                      child: Column(
                        children: [
                          Text(
                            "Change Picture",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5, left: 3),
                            child: Container(
                              height: 80,
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    padding: EdgeInsets.all(3),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(80),
                                      color: Colors.blueGrey,
                                    ),
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage(avatars[currentIndex]),
                                      radius: 25.0,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: <Widget>[
                                        getAvatars(0, setState),
                                        Container(
                                          key: Key(Keys.SecondAvatarKey),
                                          child:getAvatars(1, setState),
                                        ),
                                        getAvatars(2, setState),
                                        getAvatars(3, setState),
                                        getAvatars(4, setState),
                                        getAvatars(5, setState),
                                        getAvatars(6, setState),
                                        getAvatars(7, setState),
                                        getAvatars(8, setState),
                                        getAvatars(9, setState),
                                        getAvatars(10, setState),
                                        getAvatars(11, setState),
                                        getAvatars(12, setState),
                                        getAvatars(13, setState),
                                        getAvatars(14, setState),
                                        getAvatars(15, setState),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 30, width: 30),
                          TextFormField(
                            key: Key(Keys.UsernameField),
                            decoration: InputDecoration(labelText: "Name"),
                            //  validator: validateFirstName,
                            controller: nameController,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30, width: 30),
                    SizedBox(height: 20, width: 30),
                    RaisedButton(
                      onPressed: () {
                        saveFunction(beforeState);
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 100),
                        child: Text("SAVE",
                            key: Key(Keys.SaveButton),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }
  saveFunction(beforeState) {
    if (nameController.text != "") {
      Provider.of<CurrentUser>(context, listen: false)
          .saveInfo(currentIndex, nameController.text);
      Navigator.maybePop(context);
      beforeState(() {
        currentUser = Provider.of<CurrentUser>(context, listen: false)
            .getCurrentUser;
        profileFuture = getAllPosts(currentUser.uid);
        currentUser.photoIndex = currentIndex;
        currentUser.name = nameController.text;
      });
    }
  }

  setCurrentBookName(Book book, String bookName) {
    setState(() {
      currentBookworm.currentBook = book;
      currentBookworm.currentBookName = bookName;
    });
  }

  getAvatars(int index, StateSetter setState) {
    return MaterialButton(
      shape: CircleBorder(),
      padding: EdgeInsets.only(left: 0.0, right: 10.0, top: 0.0, bottom: 0.0),
      minWidth: 0,
      child: CircleAvatar(
        backgroundImage: AssetImage(avatars[index]),
        radius: 40.0,
      ),
      onPressed: () {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  getBookData(String uid, int index) async {
    if (libraryBooks.length <= index) {
      Book temp = await BookDatabase().getBookInfo(uid);
      libraryBooks.add(temp);
    }
  }

}
