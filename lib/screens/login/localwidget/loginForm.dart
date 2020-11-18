import 'package:bookabitual/screens/signup/signup.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../home/home.dart';

enum LoginType{
  email,
  google,
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _loginUser(LoginType type, String email, String password, BuildContext context) async{
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);
    String _returnString;
    try {
      switch (type) {
        case LoginType.email:
          _returnString = await _currentUser.loginUserWithEmail(email, password);
          break;
        case LoginType.google:
          _returnString = await _currentUser.loginUserWithGoogle();
          break;
        default:
      }

      if (_returnString == "Success") {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen(), )
        );
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch(e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No such account for the given email and password is not found. "
              "Try Again"),
          duration: Duration(seconds: 3),
        ),
      );
      print(e);
    }
  }

  Widget _googleButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        _loginUser(LoginType.google ,_emailController.text, _passwordController.text, context);
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
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
            child: Text("LOG IN",
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
            controller: _passwordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Password"
            ),
            obscureText: true,
          ),
          SizedBox(height: 20.0,),
          RaisedButton(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 100),
              child: Text("LOG IN",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            onPressed: () {
              _loginUser(
                  LoginType.email ,
                  _emailController.text,
                  _passwordController.text,
                  context);
            },
          ),
          SizedBox(height: 20,),
          _googleButton(),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage()));
            },
            child: Text("Don't have an account? Sign up here"),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

