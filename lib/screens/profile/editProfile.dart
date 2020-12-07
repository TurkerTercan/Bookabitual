import 'package:bookabitual/screens/root/root.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/bookworm.dart';
import '../../states/currentUser.dart';

class EditProfile extends StatefulWidget {
  @override
  // ignore: missing_return
  State<StatefulWidget> createState() => _EditProfileState();

}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    Bookworm _currentUser = Provider.of<CurrentUser>(context).getCurrentUser;
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
      body: ListView(
        children: <Widget>[
          Row(
            children:<Widget>[
              editPhoto(),

            ],
          ),
        ],
      ),
    );
  }


  Widget editPhoto() {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage('assets/profilePhoto5.png'),
            radius: 40.0,
            ),

          RaisedButton.icon(
            padding: EdgeInsets.only(top: 2, left: 8),
            shape: CircleBorder(),
            label: Text(''),
            icon: Icon(Icons.add),
            onPressed: (){},
            color: Colors.blueGrey,
          ),
        ],
      ),


    );
  }
}