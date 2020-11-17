import 'package:bookabitual/screens/login/login.dart';
import 'package:bookabitual/states/currentState.dart';
import 'package:bookabitual/utils/ourTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CurrentUser(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ProjectTheme().buildTheme(),
        home: LoginPage(),
      ),
    );
  }
}

