import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Auth app test", () {
    final emailField = find.byValueKey("email-field");
    final passwordField = find.byValueKey("password-field");
    final signinButton = find.byValueKey("signin-button");
    final signinMessage = find.byValueKey("message-text");

    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test("Login fails with incorrect password", () async {
      await driver.tap(emailField);
      await driver.enterText('josh@test1.com');
      await driver.tap(passwordField);
      await driver.enterText("wrongpassword");
      await driver.tap(signinButton);
      await driver.waitFor(signinMessage);
      assert(signinMessage != null);
      await driver.waitUntilNoTransientCallbacks();
    });
  });
}
