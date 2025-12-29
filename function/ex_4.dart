String checkAge (dynamic input) {
  if (validateAge(input) == false) {
    throw Exception();
  }
  return "Access granted!";
}

bool validateAge(dynamic input) {
  if (input is! num || input.isNaN) {
    throw Exception("Invalid input: Age must be an integer");
  }
  // Check conditions
  if (input < 0) {
    throw Exception("Age cannot be negative");
  }

  if (input < 18) {
    throw Exception("User is underage.");
  }
  return true;
}

void main() {
  try {
    String result = checkAge("age");
    print(result);
  } catch (e) {
    print("Error: $e");
  }
}
