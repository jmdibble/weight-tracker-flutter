import 'package:test/test.dart';
import 'package:weighttrackertwo/ui/auth/signin.dart';
import 'package:weighttrackertwo/ui/validators/email_validator.dart';
import 'package:weighttrackertwo/ui/validators/password_validator.dart';

void main() {
  test('Empty email returns error string', () {
    var result = EmailFieldValidator.validate('');
    expect(result, 'Email cannot be empty');
  });

  test('Empty password returns error string', () {
    var result = PasswordFieldValidator.validate('');
    expect(result, 'Password cannot be empty');
  });
}
