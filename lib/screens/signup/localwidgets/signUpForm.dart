import 'package:bookabitual/keys.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../validator.dart';


class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  void _signUpUser(String email, String password, String username,BuildContext context) async{
    CurrentUser _currentUser = Provider.of<CurrentUser>(context, listen: false);

    try{
      String _returnString = await _currentUser.signUpUser(email, password, username);
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
              child: Text("SIGN UP",
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              key: Key(Keys.signup_email),
              controller: _emailController,
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
              key: Key(Keys.username),
              controller: _usernameController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.account_circle_outlined),
                  hintText: "Username"
              ),
              validator: (value) {
                var valid = new Validator();
                if (valid.validateUsername(value) == UsernameValidationResults.NON_VALID) {
                  return "Non valid username";
                } else if (valid.validateUsername(value) == UsernameValidationResults.TOO_SHORT) {
                  return "Username is too short";
                } else if (valid.validateUsername(value) == UsernameValidationResults.TOO_LONG) {
                  return "Username is too long";
                } else if (valid.validateUsername(value) == UsernameValidationResults.EMPTY_USERNAME) {
                  return "Empty username";
                }
                return null;
              },
            ),
            SizedBox(height: 20.0,),
            TextFormField(
              key: Key(Keys.signup_password),
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
            TextFormField(
              key: Key(Keys.signup_confirmPassword),
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: "Confirm Password"
              ),
              obscureText: true,
              validator: (value) {
                if (_confirmPasswordController.text != _passwordController.text) {
                  return "Passwords do not match";
                }
                return null;
              },
            ),
            SizedBox(height: 20.0,),
            RaisedButton(
              key: Key(Keys.signupButton),
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
                _validateInputs();
                if (_autovalidateMode != AutovalidateMode.always) {
                  if (_passwordController.text ==
                      _confirmPasswordController.text) {
                    _signUpUser(_emailController.text, _passwordController.text,
                        _usernameController.text, context);
                  } else {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Passwords do not match"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
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
      ),
    );
  }
}