import 'package:auto_size_text/auto_size_text.dart';
import 'package:bookabitual/models/book.dart';
import 'package:bookabitual/models/bookworm.dart';
import 'package:bookabitual/screens/book/bookpage.dart';
import 'package:bookabitual/service/database.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
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
      isbn: "316107417",
      bookTitle: "Happy Trails",
      bookAuthor: "Berke Breathed",
      yearOfPublication: 1990,
      publisher: "Little Brown & Co",
      imageUrlS: "http://images.amazon.com/images/P/0679764046.01.THUMBZZZ.jpg",
      imageUrlM: "http://images.amazon.com/images/P/0679764046.01.MZZZZZZZ.jpg",
      imageUrlL: "http://images.amazon.com/images/P/0679764046.01.LZZZZZZZ.jpg",
      ratings: "1,58",
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
              child: StreamBuilder<QuerySnapshot>(
                stream: (searchName == null || searchName == "")
                    ? null
                    : bookReference
                        .limit(5)
                        .where("Book-Title", isGreaterThanOrEqualTo: searchName)
                        .where("Book-Title",
                            isLessThanOrEqualTo: searchName + "zzzzzz")
                        .snapshots(),
                builder: (context, snapshot) {
                  if (searchName == null || searchName == "") {
                    label = "Popular";
                    return ListView.builder(
                        padding: EdgeInsets.only(top: 10, right: 25, left: 25),
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
                                        MediaQuery.of(context).size.height / 8,
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
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: AutoSizeText(
                                              bookList[index].bookTitle,
                                              minFontSize: 10,
                                              maxLines: 3,
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
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.yellow[300],
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
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          );
                        });
                  } else {
                    label = "Top Results";
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (contetx, index) {
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
                              /*Bookworm user = Bookworm(
                          accountCreated: data['accountCreated'],
                          name: data['name'],
                          username: data['username'],
                          email: data['email'],
                          photoIndex: data['photoIndex'],
                        );*/

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ProjectContainer(
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 8,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Image(
                                          image: CachedNetworkImageProvider(
                                            tempBook.imageUrlM,
                                          ),
                                          fit: BoxFit.fitHeight,
                                        ),
                                        Center(
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: AutoSizeText(
                                              tempBook.bookTitle,
                                              minFontSize: 10,
                                              maxLines: 3,
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
                                                  tempBook.ratings,
                                                  style: GoogleFonts.openSans(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.yellow[300],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              tempBook.yearOfPublication
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
                              );
                            },
                          );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
