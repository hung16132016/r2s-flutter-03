abstract class Person {
  String fullName;
  String gender;
  String phone;
  String email;

  Person(this.fullName, this.gender, this.phone, this.email);

  void displayInfo() {
    print('Name: $fullName | Gender: $gender | Phone: $phone | Email: $email');
  }
}
