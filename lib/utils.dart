import 'package:easy_localization/easy_localization.dart';

class Utils {
  static String? validateEmail(String? value) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);
    if (value != null) {
      return regExp.hasMatch(value) ? null : tr("validationEmail");
    }
    return tr("validationEmail");
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return tr("validationEmpty");
    }
    if (value.length < 8) {
      return tr("validationDontEnough");
    }
    return null;
  }

  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return tr("validationEmpty");
    }
    return null;
  }
}

enum AuthorizationResult {
  success,
  errorEmail,
  errorPassword,
  errorNetwork,
  error
}

enum Gender { man, woman }

enum UserReaction { like, dislike, noReaction }

enum Language { english, russian }

Gender stringToGender(String gender) {
  if (gender == "man") {
    return Gender.man;
  } else if (gender == "woman") {
    return Gender.woman;
  }
  return Gender.woman;
}

Language languageCodeToLanguage(String langCode) {
  switch (langCode) {
    case 'ru':
      return Language.russian;
    case 'en':
      return Language.english;
    default:
      return Language.english;
  }
}

String genderToString(Gender gender) {
  switch (gender) {
    case Gender.man:
      return "man";
    case Gender.woman:
      return "woman";
    default:
      return "woman";
  }
}
