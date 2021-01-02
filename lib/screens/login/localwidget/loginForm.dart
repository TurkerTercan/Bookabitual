import 'package:bookabitual/screens/signup/signup.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:bookabitual/widgets/bookScaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../validator.dart';
import 'package:bookabitual/keys.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  Future<String> _loginUser(LoginType type, String email, String password, BuildContext context) async{
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
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => BookScaffold(),)
        );
        return "Success";
      } else {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            key: Key('LoginSuccess'),
            content: Text(_returnString),
            duration: Duration(seconds: 2),
          ),
        );
        return "Error";
      }
    } catch(e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("No such account for the given email and password was not found. "
              "Try Again"),
          duration: Duration(seconds: 3),
        ),
      );
      return e.message;
    }
  }

  Widget _googleButton(Key key) {
    return OutlineButton(
      key: key,
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
  void _validateInputs() {
    if (_formKey.currentState.validate()) {
      setState(() {
        _autovalidateMode = AutovalidateMode.disabled;
      });
    }
    else {
      setState(() {
        _autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProjectContainer(
      child: Form(
        key: _formKey,
        autovalidateMode: _autovalidateMode,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 8.0,
              ),
              child: Text("LOGIN",
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              key: Key(Keys.login_email),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.alternate_email),
                  hintText: "Email"
              ),
              validator: (value) {
                var valid = new Validator();
                if (valid.validateEmail(value) == EmailValidationResults.NON_VALID) {
                  return "Non valid mail adress";
                } else if (valid.validateEmail(value) == EmailValidationResults.EMPTY_EMAIL) {
                  return "Empty mail address";
                }
                return null;
              },
            ),
            SizedBox(height: 20.0,),
            TextFormField(
              key: Key(Keys.login_password),
              controller: _passwordController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: "Password"
              ),
              obscureText: true,
              validator: (value) {
                var valid = new Validator();
                if (valid.validatePassword(value) == PasswordValidationResults.NON_VALID) {
                  return "Non valid password";
                } else if (valid.validatePassword(value) == PasswordValidationResults.TOO_LONG) {
                  return "Password is too long";
                } else if (valid.validatePassword(value) == PasswordValidationResults.TOO_SHORT) {
                  return "Password is too short";
                } else if (valid.validatePassword(value) == PasswordValidationResults.EMPTY_PASSWORD) {
                  return "Empty password";
                }
                return null;
              },
            ),
            SizedBox(height: 20.0,),
            RaisedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100),
                child: Text("LOGIN",
                  key: Key(Keys.loginButton),
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ),
              onPressed: () async {
                _validateInputs();
                if (_autovalidateMode != AutovalidateMode.always) {
                  key: Key(Keys.Success);
                  var temp = await _loginUser(
                      LoginType.email,
                      _emailController.text,
                      _passwordController.text,
                      context);
                }
              },
            ),
            SizedBox(height: 20,),
            _googleButton(Key(Keys.loginButtonwithGoogle)),
            FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: Text("Don't have an account? Sign up here"),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}

