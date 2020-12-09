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
      body: Stack(
        children: <Widget>[
          Center(
            child: ListView(
              padding: EdgeInsets.all(20.0),
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
      padding: EdgeInsets.only(top: 20, left: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 90,
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.blueGrey,
              ),
              child: CircleAvatar(
                backgroundImage: AssetImage(avatars[_currentUser.photoIndex]),
                radius: 40.0,
              ),
            ),
            Expanded(
              child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(width: 20),
                CircleAvatar(
                  backgroundImage: AssetImage(avatars[0]),
                  radius: 40.0,
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage: AssetImage(avatars[1]),
                  radius: 40.0,
                ),
              ],
          ),
            ),
          ]
        ),
      ),
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
    return SizedBox(height: 20, width: 20);
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