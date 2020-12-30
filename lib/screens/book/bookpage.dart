import 'package:bookabitual/models/book.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  List<String> bookState = ["Finished", "Reading", "Unfinished", "Will Read"];
  List<Icon> bookStateIcon = [
    Icon(Icons.book, color: Colors.grey[300],),
    Icon(Icons.chrome_reader_mode, color: Colors.grey[300],),
    Icon(Icons.close_rounded, color: Colors.grey[300],),
    Icon(Icons.access_time, color: Colors.grey[300],),
  ];

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
                    initialRating: double.tryParse(widget.book.ratings.replaceAll(",", ".")),
                    ratingWidget: RatingWidget(
                      full: Icon(Icons.star_rounded, color: Colors.orange[200],),
                      half: Icon(Icons.star_half_rounded, color: Colors.orange[200],),
                      empty: Icon(Icons.star_border_rounded, color: Colors.orange[200],),
                    ),
                    onRatingUpdate: null,
                  ),
                ),
                SizedBox(height: 15,),
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
              ]),
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
                index = 0;
              });
              Navigator.maybePop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.chrome_reader_mode),
            title: Text('Reading'),
            onTap: (){
              setState(() {
                index = 1;
              });
              Navigator.maybePop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.close_rounded),
            title: Text('Unfinished'),
            onTap: (){
              setState(() {
                index = 2;
              });
              Navigator.maybePop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Will Read'),
            onTap: (){
              setState(() {
                index = 3;
              });
              Navigator.maybePop(context);
            },
          ),
        ],
      ),
    );
  }
}
