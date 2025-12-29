import 'dart:math';

double calculateSquareRoot(dynamic number) {
  if (validate(number) == false) {
    throw Exception();
  }

  return sqrt(number);
}

bool validate(dynamic number) {
  if (number is! num || number.isNaN) {
    throw Exception("Invalid input: Not a number.");
  }
  if (number < 0) {
    throw Exception("Square root of a negative number is not allowed.");
  }
  return true;
}

void main() {
  try {
    double result = calculateSquareRoot(9);
    print(result.toStringAsFixed(2));
  } catch (e) {
    print("Error: $e");
  }
}


