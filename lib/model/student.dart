import 'dart:io';

import 'package:flutter/cupertino.dart';

class Student with ChangeNotifier {
  int? id;
  String firstName = '';
  String lastName = '';
  String email = '';
  String? father;
  String? mother;
  DateTime? brithDate;
  int? grade;

  String? imageuri;

  File? image;

  Student(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.brithDate,
      this.father,
      this.mother,
      this.grade,
      this.image});
  Student.init();
}
