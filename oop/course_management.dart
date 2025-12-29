import 'dart:io';
import 'course.dart';

// Search function
List<Course> find(List<Course> list, String type, dynamic data) {
  return list.where((course) {
    switch (type) {
      case 'code':
        return course.code == data;
      case 'name':
        return course.name.toLowerCase().contains(data.toLowerCase());
      case 'duration':
        double? d = double.tryParse(data);
        if (d == null) return false;
        return course.duration == d;
      case 'status':
        return course.status == data;
      case 'flag':
        return course.flag == data;

      default:
        return false;
    }
  }).toList();
}

void main() {

  while (true) {
    print('1. Input course');
    print('2. Display all optional courses');
    print('3. Search courses');
    print('4. Quit');
    print('Choose an option: ');

    String choice = stdin.readLineSync()!;

    switch (choice) {
      case '1':
        Course c = Course();
        c.input();
        Course.courseList.add(c);
        print('Course added successfully.');
        break;

      case '2':
        List<Course> optionalCourses = [];

        for (Course i in Course.courseList) {
          if (i.flag.toString() == 'optional') {
            optionalCourses.add(i);
          }
        }
        if (optionalCourses.isEmpty) {
          print('No optional courses found.');
        } else {
          for (var c in optionalCourses) {
            c.output();
          }
        }
        break;

      case '3':
        print('Search by (code / name / duration / status / flag): ');
        String type = stdin.readLineSync()!.trim();

        print('Enter search value: ');
        String data = stdin.readLineSync()!.trim();

        var result = Course.find(type, data);

        if (result.isEmpty) {
          print('No courses found.');
        } else {
          for (var c in result) {
            c.output();
          }
        }
        break;

      case '4':
        print('Goodbye!');
        return;

      default:
        print('Invalid choice. Please try again.');
    }
  }
}
