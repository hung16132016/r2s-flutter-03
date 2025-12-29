import 'dart:math';
import 'dart:io';


double calculateArea(double radius) {
  return pi * radius * radius;
}

double calculatePerimeter(double radius) {
  return 2 * pi * radius;
}

void main() {
  double radius;

  while (true) {
    print('Enter the radius: ');
    String input = stdin.readLineSync()!;

    double? value = double.tryParse(input);

    if (value == null) {
      continue;
    } else {
      radius = value;
      break;
    }
  }

  print("Area of circle: ${calculateArea(radius).toStringAsFixed(2)}");
  print("Perimeter of circle: ${calculatePerimeter(radius).toStringAsFixed(2)}");
}
