import 'package:bookabitual/screens/root/root.dart';
import 'package:bookabitual/utils/avatarPictures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/bookworm.dart';
import '../../states/currentUser.dart';
import 'editProfile.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  @override
  Widget build(BuildContext context) {
    Bookworm _currentUser = Provider.of<CurrentUser>(context).getCurrentUser;
    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: <Widget>[
                  IconButton(
                    onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditProfile()),
                      );
                    },
                    icon: Icon(Icons.edit),
                    color: Colors.amber,
                    iconSize: 25.0,
                  ),
                  IconButton(
                    onPressed: () async{
                      CurrentUser _current = Provider.of<CurrentUser>(context, listen: false);
                      String _returnString = await _current.signOut();
                      if (_returnString == "Success") {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => RootPage()), (route) => false);
                      }
                    },
                    icon: Icon(Icons.logout),
                    color: Colors.amber,
                    iconSize: 25.0,
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  backgroundImage: AssetImage(avatars[_currentUser.photoIndex]),
                  radius: 40.0,
                ),
              ),
              Divider(
                height: 7,
                color: Colors.green[100],
              ),
              Text(
                _currentUser.name,
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
                height: 10,
                color: Colors.green[100],
              ),

              Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 40.0, right: 15.0, top: 10.0),
                    width: 100.0,
                    height: 20.0,
                    child: GestureDetector(
                      onTap: (){},
                      child: Text("Followers",
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black45,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 15.0, left: 10.0, top: 10.0),
                    width: 100.0,
                    height: 25.0,
                    child: GestureDetector(
                      onTap: (){},
                      child: Text("Following",
                        style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.black45,
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.normal
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          Container(
            height: 30.0,
            margin: EdgeInsets.only(top: 280.0, ),
            padding: EdgeInsets.only(left: 25.0, right: 25.0,),
            child: DefaultTabController(
              length: 2,
              child: TabBar(
                  labelPadding: EdgeInsets.all(0),
                  indicatorPadding: EdgeInsets.all(10),
                  isScrollable: true,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  labelStyle: TextStyle(fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                  unselectedLabelStyle: TextStyle(fontSize: 18.0,
                      color: Colors.grey),
                  indicator: UnderlineTabIndicator(borderSide: BorderSide(width: 2.0, color: Colors.blueGrey), insets: EdgeInsets.only(right: 10.0, left: 40.0)
                  ),
                  tabs: [
                    Tab(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(right: 25.0, left: 60.0, top: 5),
                        child: Text("My Posts"),
                      ),
                    ),
                    Tab(
                      child: Container(
                        height: 50,
                        margin: EdgeInsets.only(right: 25.0, left: 60.0, top: 5),
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