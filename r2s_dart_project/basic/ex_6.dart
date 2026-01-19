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

  for (int i = 0; i < n; i++) {
    print('Enter element ${i + 1}: ');
    arr.add(int.parse(stdin.readLineSync()!));
  }

  print('Enter target number to remove: ');
  int target = int.parse(stdin.readLineSync()!);

  List<int> result = [];
  for (int i in arr) {
    if (i != target) {
      result.add(i);
    }
  }

  print('Array after removal: $result');
}
