import 'package:bookabitual/screens/root/root.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("THIS IS OUR HOME", style: TextStyle(fontSize: 37),),
          SizedBox(height: 150),
          Center(
            child: RaisedButton(
              child: Text("Sign Out",),
              onPressed: () async {
                CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
                String _returnString = await _currentUser.signOut();
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