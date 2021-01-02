import 'package:bookabitual/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:bookabitual/keys.dart';
import 'package:bookabitual/states/currentUser.dart';
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

  testWidgets("Test of sign up successfully", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("hello@hello.com", "hello123", "hello123")).thenAnswer((realInvocation) => Future.value("Success"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: page,
      ),
    ),);

    Finder emailField = find.byKey(Key(Keys.signup_email));
    Finder passwordField = find.byKey(Key(Keys.signup_password));
    Finder confirmPasswordField = find.byKey(Key(Keys.signup_confirmPassword));
    Finder usernameField = find.byKey(Key(Keys.username));

    await tester.enterText(emailField, "hello@hello.com");
    await tester.enterText(passwordField, "hello123");
    await tester.enterText(confirmPasswordField, "hello123");
    await tester.enterText(usernameField, "hello123");

    await tester.tap(find.byKey(Key(Keys.signupButton)));

    verify(mockCurrent.signUpUser("hello@hello.com", "hello123", "hello123")).called(1);
  });

  testWidgets("Test of sign up failure - Do not match password and confirm password", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("hello@hello.com", "hello123", "hello123")).thenAnswer((realInvocation) => Future.value("Error"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: page,
      ),
    ),);

    Finder emailField = find.byKey(Key(Keys.signup_email));
    Finder passwordField = find.byKey(Key(Keys.signup_password));
    Finder confirmPasswordField = find.byKey(Key(Keys.signup_confirmPassword));
    Finder usernameField = find.byKey(Key(Keys.username));

    await tester.enterText(emailField, "hello@hello.com");
    await tester.enterText(passwordField, "hello123");
    await tester.enterText(confirmPasswordField, "hello");
    await tester.enterText(usernameField, "hello123");

    await tester.tap(find.byKey(Key(Keys.signupButton)));

    verifyNever(mockCurrent.signUpUser("hello@hello.com", "hello123", "hello123"));
  });

  testWidgets("Test of sign up failure - Password is too long.", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("hello@hello.com", "hello123hello123hello", "hello123")).thenAnswer((realInvocation) => Future.value("Error"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: page,
      ),
    ),);

    Finder emailField = find.byKey(Key(Keys.signup_email));
    Finder passwordField = find.byKey(Key(Keys.signup_password));
    Finder confirmPasswordField = find.byKey(Key(Keys.signup_confirmPassword));
    Finder usernameField = find.byKey(Key(Keys.username));

    await tester.enterText(emailField, "hello@hello.com");
    await tester.enterText(passwordField, "hello123hello123hello");
    await tester.enterText(confirmPasswordField, "hello123hello123hello");
    await tester.enterText(usernameField, "hello123");

    await tester.tap(find.byKey(Key(Keys.signupButton)));

    verifyNever(mockCurrent.signUpUser("hello@hello.com", "hello123hello123hello", "hello123"));
  });

  testWidgets("Test of sign up failure - Password is too long.", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("hello@hello.com", "hello123hello123hello", "hello123")).thenAnswer((realInvocation) => Future.value("Error"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: page,
      ),
    ),);

    Finder emailField = find.byKey(Key(Keys.signup_email));
    Finder passwordField = find.byKey(Key(Keys.signup_password));
    Finder confirmPasswordField = find.byKey(Key(Keys.signup_confirmPassword));
    Finder usernameField = find.byKey(Key(Keys.username));

    await tester.enterText(emailField, "hello@hello.com");
    await tester.enterText(passwordField, "hello123hello123hello");
    await tester.enterText(confirmPasswordField, "hello123hello123hello");
    await tester.enterText(usernameField, "hello123");

    await tester.tap(find.byKey(Key(Keys.signupButton)));

    verifyNever(mockCurrent.signUpUser("hello@hello.com", "hello123hello123hello", "hello123"));
  });

  testWidgets("Test of sign up failure - Password is too short.", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("hello", "hel", "hello123")).thenAnswer((realInvocation) => Future.value("Error"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: page,
      ),
    ),);

    Finder emailField = find.byKey(Key(Keys.signup_email));
    Finder passwordField = find.byKey(Key(Keys.signup_password));
    Finder confirmPasswordField = find.byKey(Key(Keys.signup_confirmPassword));
    Finder usernameField = find.byKey(Key(Keys.username));

    await tester.enterText(emailField, "hello");
    await tester.enterText(passwordField, "hel");
    await tester.enterText(confirmPasswordField, "hel");
    await tester.enterText(usernameField, "hello123");

    await tester.tap(find.byKey(Key(Keys.signupButton)));

    verifyNever(mockCurrent.signUpUser("hello", "hel", "hello123"));
  });

  testWidgets("Test of sign up failure - Do not enter username", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("hello@hello.com", "hello123", "")).thenAnswer((realInvocation) => Future.value("Error"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: page,
      ),
    ),);

    Finder emailField = find.byKey(Key(Keys.signup_email));
    Finder passwordField = find.byKey(Key(Keys.signup_password));
    Finder confirmPasswordField = find.byKey(Key(Keys.signup_confirmPassword));
    Finder usernameField = find.byKey(Key(Keys.username));

    await tester.enterText(emailField, "hello@hello.com");
    await tester.enterText(passwordField, "hello123");
    await tester.enterText(confirmPasswordField, "hello");
    await tester.enterText(usernameField, "");

    await tester.tap(find.byKey(Key(Keys.signupButton)));

    verifyNever(mockCurrent.signUpUser("hello@hello.com", "hello123", ""));
  });

  testWidgets("Test of sign up failure - Do not enter password", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("hello@hello.com", "", "hello123")).thenAnswer((realInvocation) => Future.value("Error"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: page,
      ),
    ),);

    Finder emailField = find.byKey(Key(Keys.signup_email));
    Finder passwordField = find.byKey(Key(Keys.signup_password));
    Finder confirmPasswordField = find.byKey(Key(Keys.signup_confirmPassword));
    Finder usernameField = find.byKey(Key(Keys.username));

    await tester.enterText(emailField, "hello@hello.com");
    await tester.enterText(passwordField, "");
    await tester.enterText(confirmPasswordField, "hello");
    await tester.enterText(usernameField, "hello123");

    await tester.tap(find.byKey(Key(Keys.signupButton)));

    verifyNever(mockCurrent.signUpUser("hello@hello.com", "", "hello123"));
  });

  testWidgets("Test of sign up failure - Do not enter confirm password", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("hello@hello.com", "hello123", "hello123")).thenAnswer((realInvocation) => Future.value("Success"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: page,
      ),
    ),);

    Finder emailField = find.byKey(Key(Keys.signup_email));
    Finder passwordField = find.byKey(Key(Keys.signup_password));
    Finder confirmPasswordField = find.byKey(Key(Keys.signup_confirmPassword));
    Finder usernameField = find.byKey(Key(Keys.username));

    await tester.enterText(emailField, "hello@hello.com");
    await tester.enterText(passwordField, "hello123");
    await tester.enterText(confirmPasswordField, "");
    await tester.enterText(usernameField, "hello123");

    await tester.tap(find.byKey(Key(Keys.signupButton)));

    verify(mockCurrent.signUpUser("hello@hello.com", "hello123", "hello123")).called(1);
  });

  testWidgets("Test of sign up failure - Do not enter mail", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("", "hello123", "hello123")).thenAnswer((realInvocation) => Future.value("Error"));
    await tester.pumpWidget(Provider<CurrentUser>(
      create: (context) => mockCurrent,
      child: MaterialApp(
        home: page,
      ),
    ),);

    Finder emailField = find.byKey(Key(Keys.signup_email));
    Finder passwordField = find.byKey(Key(Keys.signup_password));
    Finder confirmPasswordField = find.byKey(Key(Keys.signup_confirmPassword));
    Finder usernameField = find.byKey(Key(Keys.username));

    await tester.enterText(emailField, "");
    await tester.enterText(passwordField, "hello123");
    await tester.enterText(confirmPasswordField, "");
    await tester.enterText(usernameField, "hello123");

    await tester.tap(find.byKey(Key(Keys.signupButton)));

    verifyNever(mockCurrent.signUpUser("", "hello123", "hello123"));
  });
}