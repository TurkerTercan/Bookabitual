enum PasswordValidationResults {
  VALID,
  TOO_SHORT,
  EMPTY_PASSWORD,
  TOO_LONG,
  NON_VALID
}

enum EmailValidationResults{
  VALID,
  NON_VALID,
  EMPTY_EMAIL,
  USED_EMAIL
}

enum UsernameValidationResults{
  VALID,
  EMPTY_USERNAME,
  NON_VALID,
  TOO_SHORT,
  TOO_LONG,
  USED_USERNAME,
}

class Validator {
  var emailList = ["test@admin.com"];
  var usernameList = ["esra"];
  var chars = [" ","~", "!", "#", "\$", "%", "^", "&", "*", "(", ")", "=", "?", "/", "\\", ":", ";", "\"", "{", "}", "'", "<", ">", ",", "[", "]" ];

  PasswordValidationResults validatePassword(String password) {
    if (password.contains(" "))
      return PasswordValidationResults.NON_VALID;
    if (password.isEmpty)
      return PasswordValidationResults.EMPTY_PASSWORD;
    if (password.length < 8)
      return PasswordValidationResults.TOO_SHORT;
    if (password.length > 16)
      return PasswordValidationResults.TOO_LONG;
    return PasswordValidationResults.VALID;
  }

  EmailValidationResults validateEmail(String email){
    if (email.isEmpty)
      return EmailValidationResults.EMPTY_EMAIL;
    if (email.contains(" ") | !email.contains("@") | !email.contains(".com"))
      return EmailValidationResults.NON_VALID;
    if (emailList.contains(email))
      return EmailValidationResults.USED_EMAIL;
    return EmailValidationResults.VALID;
  }

  UsernameValidationResults validateUsername(String username) {
    if (username.isEmpty)
      return UsernameValidationResults.EMPTY_USERNAME;
    if (username.length < 4)
      return UsernameValidationResults.TOO_SHORT;
    if (username.length > 30)
      return UsernameValidationResults.TOO_LONG;
    if (usernameList.contains(username))
      return UsernameValidationResults.USED_USERNAME;
    for (int i = 0; i < chars.length; i++) {
      if (username.contains(chars[i]))
        return UsernameValidationResults.NON_VALID;
    }
    return UsernameValidationResults.VALID;
  }
}