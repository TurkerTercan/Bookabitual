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
  State<StatefulWidget> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController _nameController = TextEditingController();
  Bookworm _currentUser;
  int currentIndex;

  @override
  Widget build(BuildContext context) {
    _currentUser = Provider.of<CurrentUser>(context).getCurrentUser;
    _nameController.text = _currentUser.name;
    currentIndex = _currentUser.photoIndex;
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
      body: Container(
        child: ListView(
          padding: EdgeInsets.all(30.0),
          children: <Widget>[
            Text(
              "Change Picture",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            editPhoto(),
            addSpace(),
            changeName(),
            addSpace(),
            SizedBox(height: 20, width: 30),
            saveChangedButton(),
          ],
        ),
      ),
    );
  }

  Widget editPhoto() {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 3),
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
                  backgroundImage: AssetImage(avatars[currentIndex]),
                  radius: 25.0,
                ),
            ),
            SizedBox(width: 10,),
            Expanded(
              child: ListView(
              scrollDirection: Axis.horizontal,
              children:<Widget> [
                getAvatars(0),
                getAvatars(1),
                getAvatars(2),
                getAvatars(3),
                getAvatars(4),
                getAvatars(5),
                getAvatars(6),
                getAvatars(7),
                getAvatars(8),
                getAvatars(9),
                getAvatars(10),
                getAvatars(11),
                getAvatars(12),
                getAvatars(13),
                getAvatars(14),
                getAvatars(15),
              ],
             ),
            ),
          ],
        ),
      ),
    );
  }

  getAvatars(int index){
    return MaterialButton(
      shape: CircleBorder(),
      padding: EdgeInsets.only(left: 0.0 , right : 10.0 , top : 0.0 , bottom: 0.0),
      minWidth: 0,
      child: CircleAvatar(
        backgroundImage: AssetImage(avatars[index]),
        radius: 40.0,
      ),
      onPressed: () {
        currentIndex = index;
        print(index);
      },
    );
  }

  Widget changeName() {
    return TextFormField(
        decoration: InputDecoration(labelText: "Name"),
        //  validator: validateFirstName,
        controller: _nameController,
    );
  }

  Widget addSpace() {
    return SizedBox(height: 30, width: 30);
  }

  Widget saveChangedButton() {
    return RaisedButton(
      onPressed: (){
        Provider.of<CurrentUser>(context, listen: false).saveInfo(currentIndex, _nameController.text);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }
}