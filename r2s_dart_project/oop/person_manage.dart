import 'dart:io';
import 'person.dart';
import 'student.dart';
import 'teacher.dart';

bool validateEmail(String email) {
  RegExp regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
  return regex.hasMatch(email);
}

bool validateMark(double m) {
  return m >= 0 && m <= 10;
}

List<Person> people = [];

void inputPerson() {
  stdout.write('Student or Teacher (s/t): ');
  String type = stdin.readLineSync()!.toLowerCase();

  stdout.write('Full name: ');
  String name = stdin.readLineSync()!;

  stdout.write('Gender: ');
  String gender = stdin.readLineSync()!;

  stdout.write('Phone: ');
  String phone = stdin.readLineSync()!;

  String email;
  while (true) {
    stdout.write('Email: ');
    email = stdin.readLineSync()!;
    if (validateEmail(email)) break;
    print('Invalid email.');
  }

  if (type == 's') {
    stdout.write('Student ID: ');
    String id = stdin.readLineSync()!;

    double theory, practice;
    while (true) {
      stdout.write('Theory mark: ');
      theory = double.parse(stdin.readLineSync()!);
      stdout.write('Practice mark: ');
      practice = double.parse(stdin.readLineSync()!);

      if (validateMark(theory) && validateMark(practice)) break;
      print('Marks must be 0–10.');
    }

    people.add(Student(name, gender, phone, email, id, theory, practice));
  } else if (type == 't') {
    stdout.write('Basic salary: ');
    double basic = double.parse(stdin.readLineSync()!);

    stdout.write('Subsidy: ');
    double subsidy = double.parse(stdin.readLineSync()!);

    people.add(Teacher(name, gender, phone, email, basic, subsidy));
  }
}

void updateStudent() {
  stdout.write('Enter student ID: ');
  String id = stdin.readLineSync()!;

  for (var p in people) {
    if (p is Student && p.studentId == id) {
      stdout.write('New theory: ');
      p.theory = double.parse(stdin.readLineSync()!);

      stdout.write('New practice: ');
      p.practice = double.parse(stdin.readLineSync()!);

      print('Updated successfully.');
      return;
    }
  }
  print('Student not found.');
}

void displayHighSalaryTeachers() {
  for (var p in people) {
    if (p is Teacher && p.calculateSalary() > 1000) {
      p.displayInfo();
    }
  }
}

void reportPassedStudents() {
  for (var p in people) {
    if (p is Student && p.calculateFinalMark() >= 6) {
      p.displayInfo();
    }
  }
}


void main() {
  while (true) {
    print('\n===== PERSON MANAGEMENT =====');
    print('1. Input person');
    print('2. Update student by ID');
    print('3. Display teachers with salary > 1000');
    print('4. Report students passed (final >= 6)');
    print('5. Quit');
    stdout.write('Choose: ');

    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        inputPerson();
        break;

      case '2':
        updateStudent();
        break;

      case '3':
        displayHighSalaryTeachers();
        break;

      case '4':
        reportPassedStudents();
        break;

      case '5':
        print('Goodbye!');
        return;

      default:
        print('Invalid choice.');
    }
  }
}
