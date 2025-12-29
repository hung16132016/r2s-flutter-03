import 'dart:io';

int factorial(int n) {
  if (n < 0) {
    throw Exception("Factorial of negative number is not allowed.");
  }

  int result = 1;
  for (int i = 1; i <= n; i++) {
    result *= i;
  }
  return result;
}

void main() {
  try {
    int result = factorial(5);
    print(result);
  } catch (e) {
    print("Error: $e");
  }
}
