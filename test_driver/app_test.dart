import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('_formKey', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final emailTextFinder = find.byValueKey('email');
    final passwordTextFinder = find.byValueKey('password');
    final loginButtonTextFinder = find.byValueKey('loginButton');
    FlutterDriver driver;

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('Test: ', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      driver.

      expect(await driver.getText(emailTextFinder), "esra@gmail.com");
      expect(await driver.getText(passwordTextFinder), "esraesr");
    });

    test('', () async {
      // First, tap the button.
      await driver.tap(loginButtonTextFinder);

      // Then, verify the counter text is incremented by 1.
      expect(await driver.getText(emailTextFinder), "");
    });

    test('Test: ', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(emailTextFinder), "esra@gmail.com");
      expect(await driver.getText(passwordTextFinder), "esraesra");
    });

  });
}


