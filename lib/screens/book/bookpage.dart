import 'package:flutter/cupertino.dart';
import 'package:bookabitual/models/books.dart';
import 'package:flutter/material.dart';
import 'package:bookabitual/screens/search/searchPage.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../search/searchPage.dart';


class BookPage extends StatefulWidget {
  final Booksdetail booksdetail;

  BookPage({Key key, @required this.booksdetail})
      : super(key: key);


  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text("bookabitual",
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
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
        height: 49,
        color: Colors.transparent,
        child: FlatButton(
          color: Colors.black,
          onPressed: () {},
          child: Text(
            'Add to Library',
            style: GoogleFonts.openSans(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.black,
                expandedHeight: MediaQuery.of(context).size.height * 0.5,
                flexibleSpace: Container(
                  color: Color(0xFFFFD3B6),
                  height: MediaQuery.of(context).size.height * 0.5,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 25,
                        top: 35,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SearchPage()),
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
                          margin: EdgeInsets.only(bottom: 62),
                          width: 172,
                          height: 225,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage("assets/images/img_popular_book1.png"),
                              //image: AssetImage("bookdetail.img"), normalde bunların çalışması lazım ama hata alıyorum

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
                        'KORKU',
                        //bookdetail.name,
                        style: GoogleFonts.openSans(
                            fontSize: 27,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 7, left: 25),
                      child: Text(
                        'GEORGE ORWELL',
                        //booksdetail.author,
                        style: GoogleFonts.openSans(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400),
                      ),
                    ),



                  ]))
            ],
          ),
        ),
      ),

    );
  }
}