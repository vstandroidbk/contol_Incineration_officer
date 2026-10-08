class ValidationUtil {
  /// Validates 10-digit mobile number
  static String? validateMobile(String value) {
    if (value.isEmpty) {
      return "Mobile number is required";
    }

    // Remove spaces if any
    value = value.trim();

    // Check length first
    if (value.length < 10) {
      return "Enter 10 digit valid mobile number";
    }

    // If more than 10 digits (optional check)
    if (value.length > 10) {
      return "Mobile number should be exactly 10 digits";
    }

    // Check valid Indian mobile pattern (starts with 6-9)
    final RegExp mobileRegex = RegExp(r'^[6-9]\d{9}$');

    if (!mobileRegex.hasMatch(value)) {
      return "Enter valid mobile number";
    }

    return null;
  }

  static String? validateEmail(String value) {
    if (value.trim().isEmpty) {
      return "Email is required";
    }

    final RegExp emailReg = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailReg.hasMatch(value.trim())) {
      return "Invalid email format";
    }

    return null;
  }

  /// Validates name (min 2 chars, letters only)
  static String? validateName(String value, {required String fieldName}) {
    if (value.trim().isEmpty) return '$fieldName is required';
    if (!RegExp(r"^[A-Za-z ]+$").hasMatch(value)) {
      return '$fieldName can only contain letters and spaces';
    }
    return null;
  }

  /// Validates required field (generic)
  static String? validateRequired(String value, {String fieldName = "Field"}) {
    if (value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }

  /// Validates password strength (min 6 chars)
  static String? validatePassword(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  static String? validatePasswordonly(String value) {
    if (value.isEmpty) {
      return "Password is required";
    }

    if (value.length < 8) {
      return "Password must be at least 8 characters";
    }

    if (!RegExp(r'[A-Z]').hasMatch(value) ||
        !RegExp(r'[0-9]').hasMatch(value) ||
        !RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Password must contain at least one uppercase letter, one numeric, one special character.";
    }

    return null;
  }

  /// Confirms passwords match
  static String? validateConfirmPassword(
    String password,
    String confirmPassword,
  ) {
    if (confirmPassword.isEmpty) return "Confirm Password is required";
    if (password != confirmPassword) return "Passwords do not match";
    return null;
  }
}
