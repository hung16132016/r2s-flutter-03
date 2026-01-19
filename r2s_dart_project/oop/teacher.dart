import 'person.dart';

class Teacher extends Person {
  double basicSalary;
  double subsidy;

  Teacher(
      String fullName,
      String gender,
      String phone,
      String email,
      this.basicSalary,
      this.subsidy,
      ) : super(fullName, gender, phone, email);

  double calculateSalary() {
    return basicSalary + subsidy;
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print(
        'Basic Salary: $basicSalary | Subsidy: $subsidy | Salary: ${calculateSalary()}');
  }
}
