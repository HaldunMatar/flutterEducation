import 'package:flutter/cupertino.dart';

class Student with ChangeNotifier {
  int? id;
  String firstName;
  String lastName;
  String email;
  DateTime? brithDate;

  Student({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.brithDate,
  });
}
