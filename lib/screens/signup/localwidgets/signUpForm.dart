import 'package:bookabitual/widgets/ProjectContainer.dart';
import 'package:flutter/material.dart';


class SignUpForm extends StatelessWidget {
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
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.alternate_email),
                hintText: "Email"
            ),
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.account_circle_outlined),
                hintText: "Username"
            ),
          ),
          SizedBox(height: 20.0,),
          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outline),
                hintText: "Password"
            ),
            obscureText: true,
          ),
          SizedBox(height: 20.0,),
          TextFormField(
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
            onPressed: () {},
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