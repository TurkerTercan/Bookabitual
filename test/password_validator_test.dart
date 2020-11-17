import 'package:flutter_test/flutter_test.dart';
import 'package:bookabitual/validator.dart';

void main() {
  test('Password Validation Test', () {
    final validator = Validator();

    expect(validator.validatePassword(""), PasswordValidationResults.EMPTY_PASSWORD);
    expect(validator.validatePassword("pass"), PasswordValidationResults.TOO_SHORT);
    expect(validator.validatePassword("passwordvalidationtest1234567890"), PasswordValidationResults.TOO_LONG);
    expect(validator.validatePassword("    testempty    "), PasswordValidationResults.NON_VALID);
    expect(validator.validatePassword("avalidpassword"), PasswordValidationResults.VALID);

  });
}