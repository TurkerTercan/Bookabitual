import 'package:bookabitual/screens/root/root.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:bookabitual/utils/ourTheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        home: RootPage(),
      ),
    );
  }
}

