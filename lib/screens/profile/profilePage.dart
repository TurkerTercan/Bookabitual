import 'package:bookabitual/screens/root/root.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/bookworm.dart';
import '../../states/currentUser.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    Bookworm _currentUser = Provider.of<CurrentUser>(context).getCurrentUser;
    return Container(
        child: ListView(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.auto_fix_high),
                        color: Colors.amber,
                        iconSize: 25.0,
                      ),
                      SizedBox(width: 5),
                      IconButton(
                        onPressed: () async{
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
                        icon: Icon(Icons.logout),
                        color: Colors.amber,
                        iconSize: 25.0,
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage('assets/profilePhoto.jpg'),
                      radius: 40.0,
                    ),
                  ),
                  Divider(
                    height: 7,
                    color: Colors.green[100],
                  ),
                  Text(
                    'Emily',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        letterSpacing: 1.0,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Divider(
                    height: 5,
                    color: Colors.green[100],
                  ),
                  Text(
                    _currentUser.username,
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black45,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.normal
                    ),
                  ),

                  Divider(
                    height: 12,
                    color: Colors.green[100],
                  ),
                  Text(
                    'I am reading The Lord of the Rings',
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.purple[400],
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold
                    ),
                  ),

                  Divider(
                    height: 20,
                    color: Colors.green[100],
                  ),

                  Row(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 40.0, right: 15.0, top: 15.0),
                        width: 150.0,
                        height: 35.0,
                        child: RaisedButton(
                          onPressed: (){},
                          child: Text("Followers",
                            style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.black45,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal
                            ),
                          ),

                          color: Colors.blueGrey,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(right: 15.0, left: 10.0, top: 15.0),
                        width: 150.0,
                        height: 35.0,
                        child: RaisedButton(
                          onPressed: (){},
                          child: Text("Following",
                            style: TextStyle(
                                fontSize: 22.0,
                                color: Colors.black45,
                                fontFamily: 'Roboto',
                                fontWeight: FontWeight.normal
                            ),
                          ),
                          color: Colors.blueGrey,
                        ),

                      ),
                    ],
                  ),
                ],
            ),

            Container(
              height: 30.0,
              margin: EdgeInsets.only(top: 30.0),
              padding: EdgeInsets.only(left: 25.0, right: 25.0),
              child: DefaultTabController(
                length: 2,
                child: TabBar(
                    labelPadding: EdgeInsets.all(0),
                    indicatorPadding: EdgeInsets.all(0),
                    isScrollable: true,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    unselectedLabelStyle: TextStyle(fontSize: 18.0,
                        color: Colors.grey),

                    tabs: [
                  Tab(
                    child: Container(
                      margin: EdgeInsets.only(right: 25.0, left: 60.0),
                      child: Text("My Posts"),
                    ),
                  ),
                  Tab(
                    child: Container(
                      margin: EdgeInsets.only(right: 25.0, left: 60.0),
                      child: Text("My Library"),
                    ),
                  ),
                ]),
              ),
            ),
          ],
        ),
      );
  }
}