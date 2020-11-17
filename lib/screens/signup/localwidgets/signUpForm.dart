import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  void _signUpUser(String email, String password, BuildContext context) async{
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try{
      String _returnString = await _currentUser.signUpUser(email, password);
      if(_returnString == "Success")
        Navigator.pop(context);
      else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProjectContainer(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 8.0,
            ),
            child: Text("SIGN UP",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email),
                hintText: "Email"
            ),
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle_outlined),
                hintText: "Username"
            ),
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Password"
            ),
            obscureText: true,
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            controller: _confirmPasswordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Confirm Password"
            ),
            obscureText: true,
          ),
          SizedBox(height: 20.0,),
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text("SIGN UP",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
            onPressed: () {
              if (_passwordController.text == _confirmPasswordController.text) {
                print(_passwordController.text);
                _signUpUser(_emailController.text, _passwordController.text, context);
              } else {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Passwords do not match"),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
          FlatButton(
            onPressed: () {
              Navigator.maybePop(context);
            },
            child: Text("Already have an account? Log In here"),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}