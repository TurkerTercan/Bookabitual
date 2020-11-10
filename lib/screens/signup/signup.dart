import 'package:bookabitual/screens/signup/localwidgets/signUpForm.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Image.asset("assets/logo2.png"),
                  ),
                ),
                SizedBox(height: 10,),
                SignUpForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}