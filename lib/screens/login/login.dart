import 'package:bookabitual/screens/login/localwidget/loginForm.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {

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
                  padding: EdgeInsets.all(40.0),
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: Image.asset("assets/logo2.png"),
                  ),
                ),
                SizedBox(height: 20.0,),
                LoginForm(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}