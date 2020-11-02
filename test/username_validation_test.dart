import 'package:flutter_test/flutter_test.dart';
import 'package:bookabitual/validator.dart';

void main() {
  test('Username Validation Test', () {
    final validator = Validator();

    expect(validator.validateUsername("#Kerim^&*@#"), UsernameValidationResults.NON_VALID);
    expect(validator.validateUsername(""), UsernameValidationResults.EMPTY_USERNAME);
    expect(validator.validateUsername("esra"), UsernameValidationResults.USED_USERNAME);
    expect(validator.validateUsername("abc"), UsernameValidationResults.TOO_SHORT);
    expect(validator.validateUsername("cokuzunbirkullaniciadi1231231223123"), UsernameValidationResults.TOO_LONG);
    expect(validator.validateUsername("username"), UsernameValidationResults.VALID);

  });
}