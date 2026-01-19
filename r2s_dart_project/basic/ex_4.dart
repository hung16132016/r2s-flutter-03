import 'dart:io';

void main() {
  int n;

  while (true) {
    print('Enter number of elements (1-100): ');
    String input = stdin.readLineSync()!;

    int? value = int.tryParse(input);

    if (value == null || value < 1 || value > 100) {
      continue;
    } else {
      n = value;
      break;
    }
  }

  List<int> arr = [];
  int sum = 0;

  for (int i = 0; i < n; i++) {
    print('Enter element ${i + 1}: ');
    int value = int.parse(stdin.readLineSync()!);
    arr.add(value);
    sum += value;
  }

  print('Average value: ${(sum / n).toStringAsFixed(2)}');
}
