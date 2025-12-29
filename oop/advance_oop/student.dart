import 'person.dart';

class Student extends Person {
  String studentId;
  double theory;
  double practice;

  Student(
    String fullName,
    String gender,
    String phone,
    String email,
    this.studentId,
    this.theory,
    this.practice,
  ) : super(fullName, gender, phone, email);

  double calculateFinalMark() {
    return (theory + practice) / 2;
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print(
      'Student ID: $studentId | Theory: $theory | Practice: $practice | Final: ${calculateFinalMark()}',
    );
  }
}
