import 'package:flutter_test/flutter_test.dart';
import 'package:bookabitual/validator.dart';

void main() {
  test('Email Validation Test', () {
    final validator = Validator();

    expect(validator.validateEmail(""), EmailValidationResults.EMPTY_EMAIL);
    expect(validator.validateEmail("turker tercan@gmail.com"), EmailValidationResults.NON_VALID);
    expect(validator.validateEmail("seydaozergmail.com"), EmailValidationResults.NON_VALID);
    expect(validator.validateEmail("muhammetcanalkasi@gmail"), EmailValidationResults.NON_VALID);
    expect(validator.validateEmail("test@admin.com"), EmailValidationResults.USED_EMAIL);
    expect(validator.validateEmail("seymacanbaz@gmail.com"), EmailValidationResults.VALID);

  });
}