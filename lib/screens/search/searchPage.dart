import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/screens/anotherProfile/anotherProfile.dart';
import 'package:bookabitual/screens/book/bookpage.dart';
import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/utils/avatarPictures.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  final Function pageAnimation;

  const SearchPage({Key key, this.pageAnimation}) : super(key: key);


  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();
  String label = "Popular";

  List<Book> popularBooks = [
    new Book(
      isbn: "316116726",
      bookTitle: "Connections",
      bookAuthor: "James Burke",
      yearOfPublication: 1995,
      ratings: "3,36",
      publisher: "Little Brown & Co",
      imageUrlS: "http://images.amazon.com/images/P/0316116726.01.THUMBZZZ.jpg",
      imageUrlM: "http://images.amazon.com/images/P/0316116726.01.MZZZZZZZ.jpg",
      imageUrlL: "http://images.amazon.com/images/P/0316116726.01.LZZZZZZZ.jpg",
    ),
    new Book(
      isbn: "375815260",
      bookTitle: "Charlie and the Chocolate Factory",
      bookAuthor: "ROALD DAHL",
      yearOfPublication: 2001,
      publisher: "Knopf Books for Young Readers",
      imageUrlS: "http://images.amazon.com/images/P/0375815260.01.THUMBZZZ.jpg",
      imageUrlM: "http://images.amazon.com/images/P/0375815260.01.MZZZZZZZ.jpg",
      imageUrlL: "http://images.amazon.com/images/P/0375815260.01.LZZZZZZZ.jpg",
      ratings: "0,05",
    ),
    new Book(
      isbn: "312868308",
      bookTitle: "Flesh and Gold",
      bookAuthor: "Phyllis Gotlieb",
      yearOfPublication: 1999,
      publisher: "Tor Books",
      imageUrlS: "http://images.amazon.com/images/P/0312868308.01.THUMBZZZ.jpg",
      imageUrlM: "http://images.amazon.com/images/P/0312868308.01.MZZZZZZZ.jpg",
      imageUrlL: "http://images.amazon.com/images/P/0312868308.01.LZZZZZZZ.jpg",
      ratings: "1,47",
    ),
  ];

  List bookList = [];
  var searchName = "";

  var items = List<String>();
  List results = [];
  List resultsbool = [];
  Future myFuture;

  @override
  void initState() {
    bookList.addAll(popularBooks);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ProjectContainer(
                child: TextFormField(
                  onFieldSubmitted: (value) async {
                    setState(() {
                      searchName = value;
                      if (searchName == "" || searchName == null)
                        label = "Popular";
                      else
                        label = "Top Results";
                    });
                    //filterSearchResults(value);
                  },
                  controller: editingController,
                  decoration: InputDecoration(
                      labelText: "Search User or Book",
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0)))),
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(left: 25, right: 25, top: 10),
                child: Text(
                  label,
                  style: GoogleFonts.openSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 3,
              color: Colors.grey[800],
            ),
            Expanded(
              child: StreamBuilder(
                stream: (searchName == null || searchName == "")
                    ? null : userReference.limit(5)
                    .where("username", isGreaterThanOrEqualTo: searchName)
                    .where("username",
                    isLessThanOrEqualTo: searchName + "zzzzzz")
                    .snapshots(),
                builder: (context, snapshot_2) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: (searchName == null || searchName == "")
                        ? null : bookReference.limit(5)
                        .where("Book-Title", isGreaterThanOrEqualTo: searchName)
                        .where("Book-Title",
                        isLessThanOrEqualTo: searchName + "zzzzzz")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (searchName == null || searchName == "") {
                        return ListView.builder(
                            padding: EdgeInsets.only(
                                top: 5, right: 25, left: 25),
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: bookList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BookPage(book: bookList[index]),
                                    ),
                                  );
                                },
                                child: Column(
                                  children: [
                                    ProjectContainer(
                                      child: Container(
                                        height:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height / 8,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image(
                                              image: CachedNetworkImageProvider(
                                                bookList[index].imageUrlM,
                                              ),
                                              fit: BoxFit.fitHeight,
                                            ),
                                            Center(
                                              child: Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width /
                                                    3,
                                                child: AutoSizeText(
                                                  bookList[index].bookTitle,
                                                  minFontSize: 12,
                                                  maxLines: 5,
                                                  wrapWords: true,
                                                  overflow: TextOverflow.clip,
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.yellow[300],
                                                    ),
                                                    Text(
                                                      bookList[index].ratings,
                                                      style: GoogleFonts
                                                          .openSans(
                                                        fontSize: 20,
                                                        fontWeight: FontWeight
                                                            .w600,
                                                        color: Colors
                                                            .yellow[300],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Text(
                                                  bookList[index]
                                                      .yearOfPublication
                                                      .toString(),
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10,),
                                  ],
                                ),
                              );
                            });
                      } else {
                        if ((snapshot.connectionState == ConnectionState.waiting)) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                          itemCount: snapshot.data.docs.length + snapshot_2.data.docs.length,
                          itemBuilder: (context, index) {
                            if (index < snapshot.data.docs.length) {
                              DocumentSnapshot data = snapshot.data.docs[index];
                              Book tempBook = Book(
                                bookTitle: data["Book-Title"],
                                isbn: data.id,
                                bookAuthor: data["Book-Author"],
                                publisher: data["Publisher"],
                                yearOfPublication: data["Year-Of-Publication"],
                                ratings: data["Ratings"],
                                imageUrlS: data["Image-URL-S"],
                                imageUrlM: data["Image-URL-M"],
                                imageUrlL: data["Image-URL-L"],
                              );

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => BookPage(book: tempBook),),);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  child: ProjectContainer(
                                    child: Container(
                                      height: MediaQuery.of(context).size.height / 8,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context).size.width / 5,
                                            child: Image(
                                              image: CachedNetworkImageProvider(
                                                tempBook.imageUrlM,
                                              ),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          Center(
                                            child: Container(
                                              width: MediaQuery.of(context).size.width / 3,
                                              child: AutoSizeText(
                                                tempBook.bookTitle,
                                                minFontSize: 12,
                                                maxLines: 5,
                                                wrapWords: true,
                                                overflow: TextOverflow.clip,
                                                style: GoogleFonts.openSans(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Icons.star, color: Colors.yellow[300],),
                                                  Text(
                                                    tempBook.ratings,
                                                    style: GoogleFonts.openSans(
                                                      fontSize: 20,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                      color: Colors.yellow[300],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                tempBook.yearOfPublication.toString(),
                                                style: GoogleFonts.openSans(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              DocumentSnapshot data = snapshot_2.data.docs[index - snapshot.data.docs.length];
                              Bookworm tempUser = Bookworm(
                                photoIndex: data["photoIndex"],
                                uid: data.id,
                                email: data["email"],
                                username: data["username"],
                                name: data["name"],
                                accountCreated: data["accountCreated"],
                                currentBookName: data["currentBookName"],
                                followers: data["followers"],
                                following: data["following"],
                                library: data["library"],
                              );

                              return FutureBuilder(
                                future: getCurrentBook(tempUser),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState != ConnectionState.done)
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 5),
                                      child: ProjectContainer(
                                          child: Container(
                                            child: Center(child: CircularProgressIndicator()),
                                            height: MediaQuery.of(context).size.height / 8,
                                          ),
                                      ),
                                    );
                                  return GestureDetector(
                                    onTap: () {
                                      if (tempUser.uid == currentBookworm.uid)
                                        widget.pageAnimation();
                                      else
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => AnotherProfilePage(user: tempUser),),);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 5),
                                      child: ProjectContainer(
                                        child: Container(
                                          height: MediaQuery.of(context).size.height / 8,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              CircleAvatar(backgroundImage: AssetImage(avatars[tempUser.photoIndex]), radius: 40,),
                                              SizedBox(width: 20,),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(Icons.alternate_email_outlined, color: Colors.grey[300],),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width / 2,
                                                        child: AutoSizeText(
                                                          tempUser.username,
                                                          overflow: TextOverflow.ellipsis,
                                                          minFontSize: 20,
                                                          maxLines: 1,
                                                          style: GoogleFonts.openSans(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.book_outlined, color: Colors.grey[300],),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width * 0.5,
                                                        child: AutoSizeText(
                                                          tempUser.currentBook.bookTitle,
                                                          minFontSize: 20,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: GoogleFonts.openSans(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.person_outline, color: Colors.grey[300],),
                                                      Container(
                                                        width: MediaQuery.of(context).size.width / 2,
                                                        child: AutoSizeText(
                                                          tempUser.name,
                                                          overflow: TextOverflow.ellipsis,
                                                          minFontSize: 20,
                                                          maxLines: 1,
                                                          style: GoogleFonts.openSans(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                        );
                        }
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  getCurrentBook(Bookworm tempUser) async{
    tempUser.currentBook = await BookDatabase().getBookInfo(tempUser.currentBookName);
  }
}

