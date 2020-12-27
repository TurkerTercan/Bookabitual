import 'package:bookabitual/screens/home/feed.dart';
import 'package:bookabitual/screens/profile/profilePage.dart';
import 'package:bookabitual/screens/search/searchPage.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class BookScaffold extends StatefulWidget {
  BookScaffold({Key key}) :super(key: key);
  @override
  _BookScaffoldState createState() => _BookScaffoldState();
}

class _BookScaffoldState extends State<BookScaffold> {
  int _selectedItemIndex;
  var _pages = [FeedPage(), SearchPage(), ProfilePage()];
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _selectedItemIndex = 0;
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<CurrentUser>(context).signOut();
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
      body: PageView(
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedItemIndex = index;
          });
        },
        controller: _pageController,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[700],
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectedItemIndex,
        onTap: (index) {
          _selectedItemIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.linearToEaseOut);
        },
      ),

    );
  }
}

