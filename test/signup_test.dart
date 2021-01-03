import 'package:bookabitual/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:bookabitual/keys.dart';
import 'package:bookabitual/states/currentUser.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockCurrentUser extends Mock implements CurrentUser {}

void main() {
  Provider.debugCheckInvalidValueType = null;

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

  testWidgets("Test of sign up failure - Invalid Email.", (WidgetTester tester) async {
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
    await tester.enterText(confirmPasswordField, "hello123");
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

    verifyNever(mockCurrent.signUpUser("hello@hello.com", "hello123", "hello123"));
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

  testWidgets("Test of invalid character for password", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("hello@hello.com", "hello??", "hello123")).thenAnswer((realInvocation) => Future.value("Error"));
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
    await tester.enterText(passwordField, "hello??");
    await tester.enterText(confirmPasswordField, "hello??");
    await tester.enterText(usernameField, "hello123");

    await tester.tap(find.byKey(Key(Keys.signupButton)));

    verifyNever(mockCurrent.signUpUser("hello@hello.com", "hello??", "hello123"));
  });

  testWidgets("The email address is already used by another account", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("hello@hello.com", "hello123", "hello123"))
        .thenAnswer((realInvocation) => Future.value("The email address is already in use by another account."));
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
    Finder snackBarText = find.byKey(Key(Keys.SignUpSnackBar));

    await tester.enterText(emailField, "hello@hello.com");
    await tester.enterText(passwordField, "hello123");
    await tester.enterText(confirmPasswordField, "hello123");
    await tester.enterText(usernameField, "hello123");

    await tester.tap(find.byKey(Key(Keys.signupButton)));
    await tester.pump();
    var text = snackBarText.evaluate().single.widget as Text;
    expect(text.data, "The email address is already in use by another account.");
    verify(mockCurrent.signUpUser("hello@hello.com", "hello123", "hello123")).called(1);
  });

  testWidgets("Test of invalid character for password", (WidgetTester tester) async {
    SignUpPage page = SignUpPage();
    MockCurrentUser mockCurrent = MockCurrentUser();

    when(mockCurrent.signUpUser("hello@hello.com", "hello??", "hello123")).thenAnswer((realInvocation) => Future.value("Error"));
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
    await tester.enterText(passwordField, "hello??");
    await tester.enterText(confirmPasswordField, "hello??");
    await tester.enterText(usernameField, "hello123");

    await tester.tap(find.byKey(Key(Keys.signupButton)));

    verifyNever(mockCurrent.signUpUser("hello@hello.com", "hello??", "hello123"));
  });
}