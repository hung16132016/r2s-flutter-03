import 'dart:io';

class Course {
  late String code;
  late String name;
  late double duration;
  late String status;
  late String flag;

  static List<Course> courseList = [];

  bool validateCodeFormat(String code) {
    if (code.length != 5) return false;
    if (!code.startsWith('FW')) return false;

    int? suffix = int.tryParse(code.substring(2));
    return suffix != null;
  }

  bool isCodeDuplicated(String code) {
    for (Course c in courseList) {
      if (c.code == code) {
        return true;
      }
    }
    return false;
  }

  bool validateDuration(String input) {
    double? d = double.tryParse(input);
    return d != null && d > 0;
  }

  void input() {
    // Code
    while (true) {
      print('Enter course code (FWxxx): ');
      String inputCode = stdin.readLineSync()!.trim();

      if (!validateCodeFormat(inputCode)) {
        print('Invalid code format. Example: FW001');
        continue;
      }

      if (isCodeDuplicated(inputCode)) {
        print('Course code already exists.');
        continue;
      }

      code = inputCode;
      break;
    }

    // Name
    stdout.write('Enter course name: ');
    name = stdin.readLineSync()!.trim();

    // Duration
    while (true) {
      print('Enter course duration: ');
      String input = stdin.readLineSync()!;

      if (!validateDuration(input)) {
        print('Invalid duration. Please enter a positive number.');
        continue;
      }

      duration = double.parse(input);
      break;
    }

    // Status
    while (true) {
      print('Enter status (active / in-active): ');
      String s = stdin.readLineSync()!.trim().toLowerCase();
      if (s == 'active' || s == 'in-active') {
        status = s;
        break;
      } else {
        print('Invalid status.');
      }
    }

    // Flag
    while (true) {
      print('Enter flag (optional / mandatory / N/A): ');
      String f = stdin.readLineSync()!.trim().toLowerCase();
      if (f == 'optional' || f == 'mandatory' || f == 'n/a') {
        flag = f;
        break;
      } else {
        print('Invalid flag.');
      }
    }
  }

  void output() {
    print(
      'Code: $code | Name: $name | Duration: $duration | Status: $status | Flag: $flag',
    );
  }

  static List<Course> find(String type, dynamic data) {
    return courseList.where((course) {
      switch (type) {
        case 'code':
          return course.code == data;
        case 'name':
          return course.name.toLowerCase().contains(data.toLowerCase());
        case 'duration':
          double? d = double.tryParse(data);
          return d != null && course.duration == d;
        case 'status':
          return course.status == data;
        case 'flag':
          return course.flag == data;
        default:
          return false;
      }
    }).toList();
  }
}
