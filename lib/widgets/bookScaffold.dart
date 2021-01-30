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
  int selectedItemIndex;
  var pages;
  PageController _pageController = PageController();
  dynamic animation;

  void searchToProfilePage() {
    selectedItemIndex = 2;
    _pageController.animateToPage(2,
        duration: Duration(milliseconds: 300), curve: Curves.linearToEaseOut);
  }

  @override
  void initState() {
    super.initState();
    selectedItemIndex = 0;
    _pageController = PageController();
    animation = searchToProfilePage;
    pages = [FeedPage(), SearchPage(pageAnimation: animation), ProfilePage()];
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
        children: pages,
        onPageChanged: (index) {
          setState(() {
            selectedItemIndex = index;
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
        currentIndex: selectedItemIndex,
        onTap: (index) {
          selectedItemIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 300), curve: Curves.linearToEaseOut);
        },
      ),
    );
  }


}

