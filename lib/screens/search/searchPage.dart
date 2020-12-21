import 'package:bookabitual/screens/book/bookpage.dart';
import 'package:flutter/material.dart';
import 'package:bookabitual/models/books.dart';
import 'package:google_fonts/google_fonts.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController editingController = TextEditingController();

  final duplicateItems = [
    "Muhammetcan",
    "Türker",
    "Esra",
    "Seyma",
    "Seyda",
    "Muhammedcan",
    "Korku",
    "Beyaz Diş",
    "Hayvan Mezarlığı",
    "Otomatik portakal"
  ];
  var items = List<String>();

  @override
  void initState() {
    items.addAll(duplicateItems);
    super.initState();
  }

  void filterSearchResults(String query) {
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(duplicateItems);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        items.clear();
        items.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        items.clear();
        items.addAll(duplicateItems);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                  labelText: "Search User or Book",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)))),
            ),
          ),
          Container(
            height: 25,
            margin: EdgeInsets.only(top: 10),
            padding: EdgeInsets.only(right: 160),
            child: DefaultTabController(
              length: 3,
              child: TabBar(
                  labelPadding: EdgeInsets.all(0),
                  indicatorPadding: EdgeInsets.all(0),
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: GoogleFonts.openSans(
                      fontSize: 14, fontWeight: FontWeight.w700),
                  unselectedLabelStyle: GoogleFonts.openSans(
                      fontSize: 14, fontWeight: FontWeight.w600),

                  tabs: [
                    Tab(
                      child: Container(
                        margin: EdgeInsets.only(right: 23),
                        child: Text('Book'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        margin: EdgeInsets.only(right: 23),
                        child: Text('User'),
                      ),
                    ),
                    Tab(
                      child: Container(
                        margin: EdgeInsets.only(right: 23),
                        child: Text('Author'),
                      ),
                    )
                  ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, top: 25),
            child: Text(
              'Popular',
              style: GoogleFonts.openSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          ListView.builder(
              padding: EdgeInsets.only(top: 25, right: 25, left: 25),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: book.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    print('ListView Tapped');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BookPage(
                                booksdetail: book[index]),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 19),
                    height: 81,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 50,
                    color: Colors.transparent,
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 81,
                          width: 62,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                image: AssetImage(book[index].img),
                              ),
                              color: Colors.black),
                        ),

                        SizedBox(
                          width: 21,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              book[index].name,
                              style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: ListTile(
                    //title: Text('${items[index]}'),
                    onTap: () {},
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
