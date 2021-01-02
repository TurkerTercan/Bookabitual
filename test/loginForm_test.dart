import 'package:bookabitual/screens/login/login.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockAuth extends Mock implements CurrentUser{}

void main(){
  Widget makeTestableWidget({Widget child}){
    return MaterialApp(
      home: child,
    );
  }
  testWidgets('', (WidgetTester tester) async {

    LoginPage page = LoginPage();

    await tester.pumpWidget(makeTestableWidget(child: page));

  });


}