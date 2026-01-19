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

  List<int> reversedArr = [];
  for (int i = n-1; i >= 0; i--) {
    reversedArr.add(arr[i]);
  }
  print('Reversed array: $reversedArr');
}
