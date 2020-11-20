import 'package:bookabitual/screens/home/feed.dart';
import 'package:bookabitual/screens/profile/profilePage.dart';
import 'package:bookabitual/screens/search/searchPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BookScaffold extends StatefulWidget {
  final Widget body;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final Widget floatingActionButton;
  final int pageIndex;

  BookScaffold({this.body, this.floatingActionButtonLocation, this.floatingActionButton, this.pageIndex});

  @override
  _BookScaffoldState createState() => _BookScaffoldState();
}

class _BookScaffoldState extends State<BookScaffold> {
  int _selectedItemIndex;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _selectedItemIndex = widget.pageIndex;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          "bookabitual",
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
        leading: null,
      ),
      body: widget.body,
      floatingActionButtonLocation: widget.floatingActionButtonLocation,
      floatingActionButton: widget.floatingActionButton,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            buildNavBarItem(Icons.home, 0),
            buildNavBarItem(Icons.search, 1),
            buildNavBarItem(Icons.person, 2),
          ],
        ),
      ),
    );
  }

  Widget buildNavBarItem(IconData icon, int index) {

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedItemIndex = index;
          Navigator.of(context).push(_createRoute(index));
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 3,
        height: 50,
        child: Container(
          child: Icon(
            icon,
            size: 30,
            color: index == _selectedItemIndex ? Colors.black : Colors.grey,
          ),
        ),
      ),
    );
  }

  Route _createRoute(int index) {
    if(index == 0) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => FeedPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.easeOut;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }
      );
    }
    else if(index == 1) {
      return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => SearchPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.easeOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          }
      );
    } else {
      return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => ProfilePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.easeOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          }
      );
    }
  }
}

