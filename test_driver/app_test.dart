import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';
import '../lib/keys.dart';


void main() {
  Future<void> delay([int milliseconds = 250]) async {
    await Future<void>.delayed(Duration(milliseconds: milliseconds));
  }

  group('_formKey', () {
    // First, define the Finders and use them to locate widgets from the
    // test suite. Note: the Strings provided to the `byValueKey` method must
    // be the same as the Strings we used for the Keys in step 1.
    final emailTextFinder = find.byValueKey(Keys.email);
    final passwordTextFinder = find.byValueKey(Keys.password);
    final loginButtonTextFinder = find.byValueKey(Keys.loginButton);
    FlutterDriver driver;

    //A quick test to check the health status of our Flutter Driver extension.
    test('check flutter driver health', () async {
      final health = await driver.checkHealth();
      expect(health.status, HealthStatus.ok);
    });


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

    test('enters text in a text field', () async {
      await driver.tap(emailTextFinder);  // acquire focus
      await driver.enterText("esra@gmail.com");  // enter text
      await driver.tap(passwordTextFinder);  // acquire focus
      await driver.enterText('esraesra');  // enter another piece of text
      await driver.tap(loginButtonTextFinder);  // acquire focus
    });
  driver.close();

  });
}

