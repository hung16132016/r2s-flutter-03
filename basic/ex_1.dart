import 'dart:io';

void main() {
  print('Enter salary: ');
  double salary = double.parse(stdin.readLineSync()!);

  String grade;

  while (true) {
    print('Enter grade (A, B, Others): ');
    grade = stdin.readLineSync()!.trim().toUpperCase();

    // Nếu nhập số thì nhập lại
    if (int.tryParse(grade) != null) {
      continue;
    } else {
      break;
    }
  }

  double allowance;
  if (grade == 'A') {
    allowance = 300;
  } else if (grade == 'B') {
    allowance = 250;
  } else {
    allowance = 100;
  }

  print('Total salary: ${salary + allowance}');
}

