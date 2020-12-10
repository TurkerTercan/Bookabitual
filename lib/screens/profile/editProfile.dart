import 'dart:io';

import 'package:bookabitual/utils/avatarPictures.dart';
import 'package:bookabitual/validator.dart';
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

  TextEditingController _photoController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  int index;
  int i = 0;

  @override
  Widget build(BuildContext context) {
    Bookworm _currentUser = Provider.of<CurrentUser>(context).getCurrentUser;
    index = 0;
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
      body: Stack(
        children: <Widget>[
          Center(
            child: ListView(
              padding: EdgeInsets.all(30.0),
              children: <Widget>[
                editPhoto(_currentUser),
                addSpace(),
                changeName(_currentUser),
                addSpace(),
                SizedBox(height: 50, width: 30),
                saveChangedButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget editPhoto(Bookworm _currentUser) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20),
      child: Container(
        height: 80,
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(80),
                color: Colors.blueGrey,
              ),
                child: CircleAvatar(
                  backgroundImage: AssetImage(avatars[index]),
                  radius: 25.0,
                ),
            ),
            Expanded(
              child: ListView(
              scrollDirection: Axis.horizontal,
              children:<Widget> [
                getAvatars(_currentUser , 0),
                getAvatars(_currentUser , 1),
                getAvatars(_currentUser , 2),
                getAvatars(_currentUser , 3),
                getAvatars(_currentUser , 4),
                getAvatars(_currentUser , 5),
                getAvatars(_currentUser , 6),
                getAvatars(_currentUser , 7),
                getAvatars(_currentUser , 8),
                getAvatars(_currentUser , 9),
                getAvatars(_currentUser , 10),
                getAvatars(_currentUser , 11),
                getAvatars(_currentUser , 12),
                getAvatars(_currentUser , 13),
                getAvatars(_currentUser , 14),
                getAvatars(_currentUser , 15),
              ],
             ),
            ),
          ],
        ),
      ),
    );
  }



  getAvatars(Bookworm _user , int index){
    return MaterialButton(
      shape: CircleBorder(),
      padding: EdgeInsets.only(left: 0.0 , right : 10.0 , top : 0.0 , bottom: 0.0),
      minWidth: 0,
      child: CircleAvatar(
        backgroundImage: AssetImage(avatars[index]),
        radius: 40.0,
      ),
      onPressed: () {
        _user.photoIndex = index;
        print('Firebase e kaydetmeyi unutma.');
        print(index);
      },
    );
  }


  Widget changeName(_currentUser) {
    return TextFormField(
        decoration: InputDecoration(labelText: "Name"),
        //  validator: validateFirstName,
        onSaved: (String value){
          if(value != null) {
            _currentUser.name = value;
          }
        }
    );
  }

  Widget addSpace() {
    return SizedBox(height: 30, width: 30);
  }

  Widget saveChangedButton() {
    return RaisedButton(
      onPressed: (){
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }
}