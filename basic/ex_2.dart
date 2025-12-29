import 'dart:io';

void main() {
  double gpa;
  while (true) {
    print('Enter GPA (0 - 10): ');
    gpa = double.parse(stdin.readLineSync()!);

    if (gpa > 10 || gpa < 0) {
      continue;
    } else {
      break;
    }
  }

  if (gpa > 7.5) {
    print('Grade A');
  } else if (gpa > 6.0) {
    print('Grade B');
  } else if (gpa > 4.5) {
    print('Grade C');
  } else if (gpa > 3.5) {
    print('Grade D');
  } else {
    print('Grade E');
  }
}
