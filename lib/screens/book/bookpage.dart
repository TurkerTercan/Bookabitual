import 'package:bookabitual/models/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bookabitual/screens/search/searchPage.dart';
import 'package:google_fonts/google_fonts.dart';
import '../search/searchPage.dart';
import 'dart:ui';


class BookPage extends StatefulWidget {
  final Book book;

  BookPage({Key key, this.book}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          centerTitle: true,
        ),
        /*bottomNavigationBar: Container(
          margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
          height: 69,
          color: Colors.transparent,
          child: Stack(
            children: [
              ListView.builder(
                physics: BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    margin: EdgeInsets.only(bottom: 5),
                  );
                },
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  height: 50,
                  child: FittedBox(
                    child: ButtonTheme(
                      minWidth: 320,
                      height: 40,
                      child: RaisedButton(
                        color: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        onPressed: () => _onButtonPressed(),
                        child: Row(
                          children: [
                            Text(
                              "Add My Library",
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
              ),
            ],
          ),
        ),*/
        body: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                expandedHeight: MediaQuery
                    .of(context)
                    .size
                    .height * 0.5,
                flexibleSpace: Container(
                  color: Color(0xFFFFD3B6),
                  height: MediaQuery
                      .of(context)
                      .size
                      .height * 0.5,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 25,
                        top: 35,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()),
                              // Navigator.pushReplacementNamed(context, "/searchPage",);
                            );
                          },
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.transparent),
                            child: Icon(Icons.arrow_back),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
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
                      )
                    ],
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.only(top: 24, left: 25),
                    child:
                    Text(
                      widget.book.bookTitle,
                      //bookdetail.name,
                      style: GoogleFonts.openSans(
                        fontSize: 27,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7, left: 25),
                    child: Text(
                      widget.book.bookAuthor,
                      //booksdetail.author,
                      style: GoogleFonts.openSans(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _onButtonPressed() {
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        color: Colors.transparent,
        height: 226.0,
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

  Column _buildBottomNavigationMenu(){
    return Column(
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.book),
          title: Text('Finished'),
          onTap: (){},
        ),
        ListTile(
          leading: Icon(Icons.chrome_reader_mode),
          title: Text('Reading'),
          onTap: (){},
        ),
        ListTile(
          leading: Icon(Icons.close_rounded),
          title: Text('Unfinished'),
          onTap: (){},
        ),
        ListTile(
          leading: Icon(Icons.access_time),
          title: Text('Will Read'),
          onTap: (){},
        ),
      ],
    );
  }
}
