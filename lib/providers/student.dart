import 'package:flutter/cupertino.dart';

class Student with ChangeNotifier {
  int id;
  String firstName;
  String lastName;
  String email;

  Student(this.id, this.firstName, this.lastName, this.email);
}
