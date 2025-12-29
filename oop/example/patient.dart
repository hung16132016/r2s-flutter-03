class Patient {
  String name;
  int age;
  String disease;

  // Constructor
  Patient({ required this.name, required this.age, required this.disease});
}

void main() {
  Patient patient = Patient(name: "John", age: 30, disease: "Flu");

  print("Name: ${patient.name}");
  print("Age: ${patient.age}");
  print("Disease: ${patient.disease}");
}
