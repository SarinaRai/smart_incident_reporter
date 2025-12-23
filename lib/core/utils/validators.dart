import '../constants/app_strings.dart';

class Validators {
  // email validators
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return AppStrings.invalidEmail;
    }

    return null;
  }

  // validators for password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }

    return null;
  }

  // validartor for confirm password
  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }

    if (value != password) {
      return AppStrings.passwordNotMatch;
    }

    return null;
  }

  // validator for required fields
  static String? requiredField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }

  // validator for incident title
  static String? incidentTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.trim().length < 3) {
      return "Title must be at least 3 characters";
    }
    return null;
  }

  // validator for incident description
  static String? incidentDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.fieldRequired;
    }
    if (value.trim().length < 10) {
      return "Description must be at least 10 characters";
    }
    return null;
  }

  // validator for dropdown selections
  static String? dropdown(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.fieldRequired;
    }
    return null;
  }
}
