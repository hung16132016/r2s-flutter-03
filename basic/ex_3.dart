import 'dart:io';

void main() {
  int number;

  while (true) {
    print('Enter a number (2 - 9): ');
    String input = stdin.readLineSync()!;

    int? value = int.tryParse(input);

    if (value == null || value > 9 || value < 2) {
      continue;
    } else {
      number = value;
      break;
    }
  }

  for (int i = 2; i <= 9; i++) {
    print('$number x $i = ${number * i}');
  }
}
