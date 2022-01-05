import 'package:flutter/cupertino.dart';

class Student with ChangeNotifier {
  int? id;
  String firstName;
  String lastName;
  String email;

  Student(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.email});
}
