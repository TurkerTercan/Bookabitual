import 'package:flutter/material.dart';
import 'package:bookabitual/keys.dart';
import 'package:bookabitual/screens/login/login.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockCurrentUser extends Mock implements CurrentUser {}

class ProviderTest extends StatelessWidget {
  final CurrentUser user;
  final Widget child;

  const ProviderTest({Key key, this.user, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => user,
      child: MaterialApp(
        home: child,
      ),
    );
  }
}

void main() {

  Provider.debugCheckInvalidValueType = null;

  Widget makeTestableWidget({Widget child, CurrentUser user}) {
    return ProviderTest(
      child: child,
      user: user,
    );
  }

  testWidgets("empty password and email, validator will not allow them to execute", (WidgetTester tester) async {
    LoginPage page = LoginPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.loginUserWithEmail('', '')).thenAnswer((realInvocation) => Future.value("Error"));
    
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: makeTestableWidget(child: page, user: mockCurrent),
    ),);

    await tester.tap(find.byKey(Key(Keys.loginButton)));
    verifyNever(mockCurrent.loginUserWithEmail('', ''));
  });
  
  testWidgets('Successful login', (WidgetTester tester) async {
    LoginPage page = LoginPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.loginUserWithEmail("hello@hello.com", "hello123")).thenAnswer((realInvocation) => Future.value("Success"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: page,
      ),
    ),);
    
    Finder emailField = find.byKey(Key(Keys.login_email));
    Finder passwordField = find.byKey(Key(Keys.login_password));
    
    await tester.enterText(emailField, "hello@hello.com");
    await tester.enterText(passwordField, "hello123");

    await tester.tap(find.byKey(Key(Keys.loginButton)));
    
    verify(mockCurrent.loginUserWithEmail("hello@hello.com", "hello123")).called(1);
  });


  testWidgets('Invalid Password - Too short', (WidgetTester tester) async {
    LoginPage page = LoginPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.loginUserWithEmail("hello@hello.com", "hel")).thenAnswer((realInvocation) => Future.value("Error"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: makeTestableWidget(child: page, user: mockCurrent),
    ),);

    Finder emailField = find.byKey(Key(Keys.login_email));
    Finder passwordField = find.byKey(Key(Keys.login_password));

    await tester.enterText(emailField, "hello@hello.com");
    await tester.enterText(passwordField, "hel");

    await tester.tap(find.byKey(Key(Keys.loginButton)));

    verifyNever(mockCurrent.loginUserWithEmail("hello@hello.com", "hel"));
  });


  testWidgets('Invalid Password - Too long', (WidgetTester tester) async {
    LoginPage page = LoginPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.loginUserWithEmail("hello@hello.com", "1111111111111111111111111111111")).thenAnswer((realInvocation) => Future.value("Error"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: makeTestableWidget(child: page, user: mockCurrent),
    ),);

    Finder emailField = find.byKey(Key(Keys.login_email));
    Finder passwordField = find.byKey(Key(Keys.login_password));

    await tester.enterText(emailField, "hello@hello.com");
    await tester.enterText(passwordField, "1111111111111111111111111111111");

    await tester.tap(find.byKey(Key(Keys.loginButton)));

    verifyNever(mockCurrent.loginUserWithEmail("hello@hello.com", "1111111111111111111111111111111"));
  });

  testWidgets('Invalid Email Address', (WidgetTester tester) async {
    LoginPage page = LoginPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.loginUserWithEmail("hello", "hello123")).thenAnswer((realInvocation) => Future.value("Error"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: makeTestableWidget(child: page, user: mockCurrent),
    ),);

    Finder emailField = find.byKey(Key(Keys.login_email));
    Finder passwordField = find.byKey(Key(Keys.login_password));

    await tester.enterText(emailField, "hello");
    await tester.enterText(passwordField, "hello123");

    await tester.tap(find.byKey(Key(Keys.loginButton)));

    verifyNever(mockCurrent.loginUserWithEmail("hello", "hello123"));
  });

  /*testWidgets('Login in with Google Method', (WidgetTester tester) async {
    LoginPage page = LoginPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.loginUserWithGoogle()).thenAnswer((realInvocation) => Future.value("Success"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: makeTestableWidget(child: page, user: mockCurrent),
    ),);

    Finder googleButton = find.byKey(Key(Keys.loginButtonwithGoogle));
    print(googleButton);
    await tester.tap(googleButton);

    verify(mockCurrent.loginUserWithGoogle()).called(1);
  });*/

}