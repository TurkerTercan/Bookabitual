import 'package:bookabitual/screens/root/root.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    CurrentUser _currentUser = Provider.of<CurrentUser>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("This is our home page. Welcome " + _currentUser.getCurrentUser.username,
            style: TextStyle(fontSize: 37),
          ),
          SizedBox(height: 150),
          Center(
            child: RaisedButton(
              child: Center(child: Text("Sign Out",)),
              onPressed: () async {
                CurrentUser _current = Provider.of<CurrentUser>(context, listen: false);
                String _returnString = await _current.signOut();
                if (_returnString == "Success") {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RootPage()
                      ), (route) => false);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}