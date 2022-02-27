import 'package:flutter/cupertino.dart';

class Student with ChangeNotifier {
  int? id;
  String firstName;
  String lastName;
  String email;
  DateTime? brithDate;
  int? grade;

  Student({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.brithDate,
    this.grade,
  });
}
