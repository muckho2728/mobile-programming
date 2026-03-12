class FormValidators {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Name is required";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Email is required";
    }
    if (!value.contains("@") || !value.contains(".")) {
      return "Invalid email format";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Password required";
    }
    if (value.length < 8) {
      return "Min 8 characters";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Must contain a number";
    }
    return null;
  }

  static String? validateConfirmPassword(
      String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Confirm password required";
    }
    if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }
}