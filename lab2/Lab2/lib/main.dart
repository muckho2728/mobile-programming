// ===============================
// Lab 2 – Dart Essentials Practice
// ===============================

void main() async {
  print("===== Exercise 1: Basic Syntax & Data Types =====");
  exercise1();

  print("\n===== Exercise 2: Collections & Operators =====");
  exercise2();

  print("\n===== Exercise 3: Control Flow & Functions =====");
  exercise3();

  print("\n===== Exercise 4: Intro to OOP =====");
  exercise4();

  print("\n===== Exercise 5: Async, Future, Null Safety & Streams =====");
  await exercise5();
}

// ------------------------------------------------
// Exercise 1 – Basic Syntax & Data Types
// ------------------------------------------------
void exercise1() {
  int age = 21;
  double gpa = 3.6;
  String name = "Phong";
  bool isStudent = true;

  print("Name: $name");
  print("Age: $age");
  print("GPA: $gpa");
  print("Is student: $isStudent");
  print("Next year age: ${age + 1}");
}

// ------------------------------------------------
// Exercise 2 – Collections & Operators
// ------------------------------------------------
void exercise2() {
  // List
  List<int> numbers = [1, 2, 3, 4, 5];
  numbers.add(6);
  numbers.remove(2);

  print("Numbers list: $numbers");
  print("First element: ${numbers[0]}");

  // Operators
  int a = 10;
  int b = 5;
  print("a + b = ${a + b}");
  print("a > b = ${a > b}");
  print("a == b = ${a == b}");
  print("a > 0 && b > 0 = ${a > 0 && b > 0}");

  // Ternary operator
  String result = a > b ? "a is greater" : "b is greater";
  print(result);

  // Set (unique values)
  Set<String> fruits = {"Apple", "Banana", "Apple"};
  fruits.add("Orange");
  print("Fruits set: $fruits");

  // Map (key-value)
  Map<String, int> scores = {
    "Math": 90,
    "English": 85
  };

  scores["Science"] = 95;
  print("Scores map: $scores");
  print("Math score: ${scores["Math"]}");
}

// ------------------------------------------------
// Exercise 3 – Control Flow & Functions
// ------------------------------------------------
void exercise3() {
  int score = 75;

  // if / else
  if (score >= 80) {
    print("Grade: A");
  } else if (score >= 60) {
    print("Grade: B");
  } else {
    print("Grade: C");
  }

  // switch case
  int day = 3;
  switch (day) {
    case 1:
      print("Monday");
      break;
    case 2:
      print("Tuesday");
      break;
    case 3:
      print("Wednesday");
      break;
    default:
      print("Other day");
  }

  // Loops
  List<int> values = [10, 20, 30];

  for (int i = 0; i < values.length; i++) {
    print("for loop: ${values[i]}");
  }

  for (var v in values) {
    print("for-in loop: $v");
  }

  values.forEach((v) {
    print("forEach loop: $v");
  });

  // Functions
  print("Sum (normal function): ${sum(3, 4)}");
  print("Multiply (arrow function): ${multiply(3, 4)}");
}

int sum(int x, int y) {
  return x + y;
}

int multiply(int x, int y) => x * y;

// ------------------------------------------------
// Exercise 4 – Intro to OOP
// ------------------------------------------------
void exercise4() {
  Car car1 = Car("Toyota");
  Car car2 = Car.named("Honda");

  ElectricCar eCar = ElectricCar("Tesla", 100);

  car1.drive();
  car2.drive();
  eCar.drive();
}

class Car {
  String brand;

  // Default constructor
  Car(this.brand);

  // Named constructor
  Car.named(this.brand);

  void drive() {
    print("The car brand is $brand");
  }
}

class ElectricCar extends Car {
  int batteryLevel;

  ElectricCar(String brand, this.batteryLevel) : super(brand);

  // Method overriding
  @override
  void drive() {
    print("Electric car $brand with battery $batteryLevel%");
  }
}

// ------------------------------------------------
// Exercise 5 – Async, Future, Null Safety & Streams
// ------------------------------------------------
Future<void> exercise5() async {
  // Async / Await with Future
  await loadData();

  // Null safety
  String? username;
  print("Username: ${username ?? "Guest"}");

  username = "Phong";
  print("Username length: ${username!.length}");

  // Stream
  Stream<int> numberStream = Stream.fromIterable([1, 2, 3, 4, 5]);

  numberStream.listen((value) {
    print("Stream value: $value");
  });
}

Future<void> loadData() async {
  print("Loading data...");
  await Future.delayed(Duration(seconds: 2));
  print("Data loaded!");
}
