class AppTextfieldValidation {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Simple email regex pattern
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null; // Return null if the email is valid
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    if (value.contains(" ")) {
      return "Password should not contain spaces";
    }
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return "Password should contain at least one uppercase letter";
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return "Password should contain at least one lowercase letter";
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return "Password should contain at least one digit";
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return "Password should contain at least one special character";
    }
    return null; // Return null if the password is valid
  }

  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3 || value.length > 15) {
      return 'Username must be between 3 and 15 characters long';
    }
    if (value.contains("https")) {
      return "Username should not contain https";
    }
    if (value.contains("http")) {
      return "Username should not contain http";
    }
    if (value.contains("www.")) {
      return "Username should not contain www.";
    }

    return null; // Return null if the username is valid
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    // Check if length exceeds 10 digits
    if (value.length > 10) {
      return 'Phone number cannot exceed 10 digits';
    }
    // Simple phone number regex pattern (10 digits)
    final phoneRegex = RegExp(r'^\d{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null; // Return null if the phone number is valid
  }

  static String? validateAge(String? value) {
    if (value == null || value.isEmpty) {
      return 'Age is required';
    }
    // Check if the input is a valid integer
    final age = int.tryParse(value);
    if (age == null) {
      return 'Please enter a valid age';
    }
    // Check if age is within a reasonable range (e.g., 0-120)
    if (age < 0 || age > 120) {
      return 'Please enter a valid age between 0 and 120';
    }
    return null; // Return null if the age is valid
  }
}
