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
    TextEditingController _photoController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _confirmPasswordController = TextEditingController();
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
                changeUsername(_currentUser),
                addSpace(),
                changePassword(_currentUser),
                SizedBox(height: 50, width: 30),
                saveChangedButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget editPhoto(_currentUser) {
    return Container(
      padding: EdgeInsets.only(top: 20, left: 20),
      child: Stack(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage(_currentUser.photo),
            radius: 40.0,
          ),

          RaisedButton.icon(
            padding: EdgeInsets.only(top: 2, left: 8),
            shape: CircleBorder(),
            label: Text(''),
            icon: Icon(Icons.add),
            color: Colors.blueGrey,
            onPressed: (){},
          ),
        ],
      ),
    );
  }
  Widget changeName(_currentUser) {
    return TextFormField(
        decoration: InputDecoration(labelText: "Name"),
        //  validator: validateFirstName,
        onSaved: (String value){
          _currentUser.name = value;
        }
    );
  }

  Widget changeUsername( _currentUser) {
    return TextFormField(
        decoration: InputDecoration(labelText: "Username"),
        //  validator: validateFirstName,
        onSaved: (String value){
          _currentUser.username = value;
        }
    );
  }

  Widget changePassword( _currentUser) {
    return TextFormField(
        decoration: InputDecoration(labelText: "Password"),
        //  validator: validateFirstName,
        onSaved: (String value){
          _currentUser.password= value;
        }
    );
  }

  Widget addSpace() {
    return SizedBox(height: 20, width: 20);
  }

  Widget saveChangedButton() {
    return RaisedButton(
      onPressed: (){},
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100),
        child: Text("SAVE", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
    );
  }
}